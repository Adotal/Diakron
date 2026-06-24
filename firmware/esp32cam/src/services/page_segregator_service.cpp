#include "page_segregator_service.h"
#include "../web/page_segregator.h"

DebugWebService::DebugWebService(AsyncWebServer& srv)
    : server(srv)
{
}

void DebugWebService::init()
{
    server.on("/", HTTP_GET,
        [](AsyncWebServerRequest *request)
        {
            request->send_P(200, "text/html", DEBUG_PAGE);
        });
}