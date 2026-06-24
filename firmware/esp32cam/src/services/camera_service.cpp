#include "camera_service.h"
#include "freertos/FreeRTOS.h"
#include <HTTPClient.h>
#include <WiFiClientSecure.h>
#include <WebSocketsClient.h>

extern WebSocketsClient webSocketSrvr;

CameraService::CameraService(const char *url)
{
    backendURL = url;
}

void CameraService::attachWebSocket(WebSocketService *ws)
{
    wsService = ws;
}

void CameraService::init()
{
    camera_config_t config;

    // ---------------- PIN CONFIG ----------------
    config.pin_pwdn = PWDN_GPIO_NUM;
    config.pin_reset = RESET_GPIO_NUM;
    config.pin_xclk = XCLK_GPIO_NUM;
    config.pin_sccb_sda = SIOD_GPIO_NUM;
    config.pin_sccb_scl = SIOC_GPIO_NUM;

    config.pin_d7 = Y9_GPIO_NUM;
    config.pin_d6 = Y8_GPIO_NUM;
    config.pin_d5 = Y7_GPIO_NUM;
    config.pin_d4 = Y6_GPIO_NUM;
    config.pin_d3 = Y5_GPIO_NUM;
    config.pin_d2 = Y4_GPIO_NUM;
    config.pin_d1 = Y3_GPIO_NUM;
    config.pin_d0 = Y2_GPIO_NUM;

    config.pin_vsync = VSYNC_GPIO_NUM;
    config.pin_href = HREF_GPIO_NUM;
    config.pin_pclk = PCLK_GPIO_NUM;

    // ---------------- CLOCK ----------------
    config.xclk_freq_hz = 20000000;
    config.ledc_timer = LEDC_TIMER_0;
    config.ledc_channel = LEDC_CHANNEL_0;

    // ---------------- FORMAT ----------------
    config.pixel_format = PIXFORMAT_JPEG;

    // ---------------- QUALITY ----------------
    config.frame_size = FRAMESIZE_VGA;
    config.jpeg_quality = 10;
    config.fb_count = 2;                     // 2 buffers para mayor estabilidad
    config.fb_location = CAMERA_FB_IN_PSRAM; // USING PSRAM
    config.grab_mode = CAMERA_GRAB_LATEST;   // Mejor para capturas bajo demanda

    // ---------------- INIT CAMERA ----------------
    esp_err_t err = esp_camera_init(&config);

    if (err != ESP_OK)
    {
        String errorMsg = "Camera init failed: 0x" + String(err, HEX);
        Logger::error(errorMsg.c_str());
        return;
    }

    Logger::info("Camera initialized");
    xTaskCreatePinnedToCore(
        cameraTask,
        "camera_task",
        20000,
        this,
        1,
        &cameraTaskHandle,
        0);
}

void CameraService::requestCapture()
{
    if (captureRequested)
        return;

    newPhotoAvailable = false;
    captureFailed = false;

    captureRequested = true;
}

void CameraService::cameraTask(void *param)
{
    CameraService *self = static_cast<CameraService *>(param);

    while (true)
    {
        if (self->captureRequested)
        {
            self->captureRequested = false;

            self->processCapture();
        }

        vTaskDelay(pdMS_TO_TICKS(50));
    }
}

void CameraService::processCapture()
{
    camera_fb_t *fb = esp_camera_fb_get();

    if (!fb)
    {
        Logger::error("Camera capture failed");

        captureFailed = true;

        return;
    }

    Logger::info(("IMG SIZE: " + String(fb->len)).c_str());

    // SEND IMAGE TO HMI

    if (wsService != nullptr)
    {
        size_t totalSize = fb->len + 2;

        uint8_t *packet = (uint8_t *)malloc(totalSize);

        if (packet == nullptr)
        {
            Logger::error("NO MEM FOR WS IMAGE");
        }
        else
        {
            packet[0] = 'I';
            packet[1] = 'M';

            memcpy(packet + 2, fb->buf, fb->len);

            wsService->sendBinary(packet, totalSize);

            free(packet);
        }
    }

    // SEND IMAGE TO BACKEND

    bool success =
        sendPhotoToBackend(fb);

    esp_camera_fb_return(fb);

    if (success)
    {
        newPhotoAvailable = true;

        captureFailed = false;
    }
    else
    {
        captureFailed = true;
    }

    vTaskDelay(pdMS_TO_TICKS(200));
}

bool CameraService::sendPhotoToBackend(camera_fb_t *fb)
{
    Logger::info("[CAM] Iniciando envío secuencial. Desconectando WebSocket temporalmente...");
    
    webSocketSrvr.disconnect();
    
    vTaskDelay(pdMS_TO_TICKS(600)); 

    Logger::info("[CAM] Memoria liberada. Abriendo canal HTTPS para la foto...");

    WiFiClientSecure client;
    client.setInsecure(); // Avoid loading large certificates into RAM.

    HTTPClient http;
    http.useHTTP10(true);
    http.begin(client, backendURL);
    http.addHeader("Content-Type", "image/jpeg");
    http.setTimeout(30000);

    yield();
    int httpCode = http.sendRequest("POST", fb->buf, fb->len);
    yield();

    bool success = false;

    if (httpCode > 0)
    {
        lastPrediction = http.getString();
        Logger::info(("[CAM] Respuesta del Backend: " + lastPrediction).c_str());
        success = true;
    }
    else
    {
        String errorMsg = "[CAM] ERROR HTTP: " + String(httpCode) + " => " + http.errorToString(httpCode);
        Logger::error(errorMsg.c_str());
    }

    // CLOSE AND RELEASE THE HTTP CONNECTION IMMEDIATELY
    http.end();
    client.stop();

    vTaskDelay(pdMS_TO_TICKS(300)); 

    Logger::info("[CAM] Foto procesada. Reactivando bucle del WebSocket...");
    
    // RECONNECT THE WEBSOCKET
    // In the setup() function `webSocketSrvr.setReconnectInterval(5000);` is configured,
    // the WebSocket client will attempt to reconnect automatically in a few seconds.

    return success;
}

bool CameraService::hasNewResult()
{
    return newPhotoAvailable;
}

String CameraService::getPrediction()
{
    newPhotoAvailable = false;

    return lastPrediction;
}

bool CameraService::hasFailed()
{
    return captureFailed;
}

void CameraService::clearFailure()
{
    captureFailed = false;
}