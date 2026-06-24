#pragma once

#include <Arduino.h>
#include <esp_camera.h>
#include <HTTPClient.h>
#include <WiFiClientSecure.h>

#define CAMERA_MODEL_AI_THINKER

#include "../config/camera_pins.h"
#include "../communication/logger.h"
#include "websocket_service.h"

class CameraService
{
private:

    String lastPrediction;

    volatile bool captureRequested = false;
    volatile bool newPhotoAvailable = false;
    volatile bool captureFailed = false;

    TaskHandle_t cameraTaskHandle = nullptr;

    const char* backendURL;

    WebSocketService* wsService = nullptr;

    static void cameraTask(void* param);

    void processCapture();

    bool sendPhotoToBackend(camera_fb_t* fb);

public:

    CameraService(const char* url);

    void init();

    void attachWebSocket(WebSocketService* ws);

    void requestCapture();

    bool hasNewResult();

    String getPrediction();

    bool hasFailed();

    void clearFailure();
};