#pragma once

#include <ESPAsyncWebServer.h>

class DebugWebService
{
private:
    AsyncWebServer& server;

public:
    DebugWebService(AsyncWebServer& srv);

    void init();
};