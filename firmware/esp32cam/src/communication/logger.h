#pragma once
#include <Arduino.h>
#include "../services/websocket_service.h"
class Logger
{
private: 
    static WebSocketService* _wsService;
public:
    static void info(const char* msg);
    static void error(const char* msg);
    static void state(const char* msg);
    static void setWebSocketService(WebSocketService* ws) { _wsService = ws; }
};