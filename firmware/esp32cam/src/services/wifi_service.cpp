#include "wifi_service.h"
#include "../communication/logger.h"

WifiService::WifiService()
{
}

void WifiService::init(AsyncWebServer &srv, InterfaceUI &displayUI)
{
    server = &srv;
    ui = &displayUI;

    prefs.begin("wifi", false);

    configureRoutes();

    if (!connectToSavedWifi())
    {
        Logger::error("FAILED TO CONNECT");

        startConfigPortal();
    }
}

void WifiService::loadSavedNetworkConfig()
{
    ssid = prefs.getString("ssid", "");
    password = prefs.getString("pass", "");

    local_IP.fromString(
        prefs.getString("ip", ""));

    gateway.fromString(
        prefs.getString("gateway", ""));

    subnet.fromString(
        prefs.getString("subnet", ""));

    primaryDNS.fromString(
        prefs.getString("dns1", ""));

    secondaryDNS.fromString(
        prefs.getString("dns2", ""));
}

bool WifiService::connectToSavedWifi()
{
    loadSavedNetworkConfig();

    if (ssid == "")
    {
        Logger::error("NO SAVED WIFI");

        return false;
    }

    WiFi.mode(WIFI_STA);

    WiFi.config(
        local_IP,
        gateway,
        subnet,
        primaryDNS,
        secondaryDNS);
    ui->setWifiInfo(
        ssid,
        password,
        "0.0.0.0",
        false);

    ui->setState(UI_CONNECTING_WIFI);

    WiFi.begin(
        ssid.c_str(),
        password.c_str());

    Logger::info("CONNECTING TO WIFI");

    unsigned long start = millis();

    while (WiFi.status() != WL_CONNECTED)
    {
        ui->update();

        delay(500);

        Serial.print(".");

        if (millis() - start > 15000)
        {
            Logger::error("WIFI TIMEOUT");

            return false;
        }
    }

    String ip =
        WiFi.localIP().toString();

    Logger::info(
        ("CONNECTED IP: " + ip).c_str());

    ui->setWifiInfo(
        ssid,
        password,
        ip,
        false);

    ui->setState(UI_WIFI_STATUS);

    delay(6000);

    ui->setState(UI_MENU);

    return true;
}

void WifiService::startConfigPortal()
{
    WiFi.disconnect(true);

    WiFi.mode(WIFI_AP);

    WiFi.softAP(
        "Diakron-Setup",
        "12345678");
    IPAddress IP = WiFi.softAPIP();

    Logger::info(
        ("CONFIG AP IP: " +
         WiFi.softAPIP().toString())
            .c_str());
    ui->setWifiInfo(
        "Diakron-Setup",
        "12345678",
        IP.toString(),
        true);
    ui->setState(UI_AP_MODE);
}

void WifiService::configureRoutes()
{
    /*
    ========================================
                GET WIFI CONFIG
    ========================================
    */

    server->on("/wifi/config",
               HTTP_GET,
               [&](AsyncWebServerRequest *request)
               {
                   JsonDocument doc;

                   doc["ssid"] =
                       prefs.getString("ssid");

                   doc["password"] =
                       prefs.getString("pass");

                   doc["ip"] =
                       prefs.getString("ip");

                   doc["gateway"] =
                       prefs.getString("gateway");

                   doc["subnet"] =
                       prefs.getString("subnet");

                   doc["dns1"] =
                       prefs.getString("dns1");

                   doc["dns2"] =
                       prefs.getString("dns2");

                   doc["connected"] =
                       WiFi.status() == WL_CONNECTED;

                   doc["currentIP"] =
                       WiFi.localIP().toString();

                   String output;

                   serializeJson(doc, output);

                   request->send(
                       200,
                       "application/json",
                       output);
               });

    /*
    ========================================
                SAVE WIFI CONFIG
    ========================================
    */

    server->on(
        "/wifi/save",
        HTTP_POST,

        [](AsyncWebServerRequest *request) {},

        NULL,

        [&](AsyncWebServerRequest *request,
            uint8_t *data,
            size_t len,
            size_t index,
            size_t total)
        {
            JsonDocument doc;

            DeserializationError err =
                deserializeJson(doc, data);

            if (err)
            {
                request->send(
                    400,
                    "text/plain",
                    "INVALID JSON");

                return;
            }

            saveCredentials(
                doc["ssid"].as<String>(),
                doc["password"].as<String>(),
                doc["ip"].as<String>(),
                doc["gateway"].as<String>(),
                doc["subnet"].as<String>(),
                doc["dns1"].as<String>(),
                doc["dns2"].as<String>());

            request->send(
                200,
                "text/plain",
                "OK");

            delay(1000);

            ESP.restart();
        });

    /*
    ========================================
                    REBOOT
    ========================================
    */

    server->on("/reboot",
               HTTP_GET,
               [](AsyncWebServerRequest *request)
               {
                   request->send(
                       200,
                       "text/plain",
                       "REBOOTING");

                   delay(1000);

                   ESP.restart();
               });
}

void WifiService::saveCredentials(
    String ssid,
    String password,
    String ip,
    String gateway,
    String subnet,
    String dns1,
    String dns2)
{
    prefs.putString("ssid", ssid);

    prefs.putString("pass", password);

    prefs.putString("ip", ip);

    prefs.putString("gateway", gateway);

    prefs.putString("subnet", subnet);

    prefs.putString("dns1", dns1);

    prefs.putString("dns2", dns2);

    Logger::info("WIFI CONFIG SAVED");
}

bool WifiService::isConnected()
{
    return WiFi.status() == WL_CONNECTED;
}

String WifiService::getIP()
{
    return WiFi.localIP().toString();
}