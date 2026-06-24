#pragma once

#include <WiFi.h>
#include <ESPAsyncWebServer.h>
#include <Preferences.h>
#include <ArduinoJson.h>
#include "../communication/logger.h"
#include "../core/interfaceUI.h"
class WifiService
{
private:

    Preferences prefs;

    AsyncWebServer* server;
    InterfaceUI* ui;

    String ssid;
    String password;

    IPAddress local_IP;
    IPAddress gateway;
    IPAddress subnet;
    IPAddress primaryDNS;
    IPAddress secondaryDNS;

    bool connectToSavedWifi();

    void startConfigPortal();

    void configureRoutes();

    void loadSavedNetworkConfig();

    void saveCredentials(
        String ssid,
        String password,
        String ip,
        String gateway,
        String subnet,
        String dns1,
        String dns2);

public:

    WifiService();

    void init(AsyncWebServer& srv, InterfaceUI& displayUI);

    bool isConnected();

    String getIP();
};