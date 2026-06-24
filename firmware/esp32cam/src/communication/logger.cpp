#include "logger.h"

WebSocketService* Logger::_wsService = nullptr;

void Logger::info(const char* msg)
{
    String formatted = "[INFO] " + String(msg);
    Serial.println(formatted);
    
    if (_wsService) {
        _wsService->sendText(formatted);
    }
}

void Logger::error(const char* msg)
{
    String formatted = "[ERROR] " + String(msg);
    Serial.println(formatted);
    
    if (_wsService) {
        _wsService->sendText(formatted);
    }
}

void Logger::state(const char* msg)
{
    String formatted = "[STATE] " + String(msg);
    Serial.println(formatted);
    
    if (_wsService) {
        _wsService->sendText(formatted);
    }
}