#pragma once
#include "../hal/IPinDriver.h"

class PIRSensor
{
private:
    IPinDriver &driver;
    uint8_t pin;
    bool inverted;

public:
    PIRSensor(IPinDriver &drv, uint8_t p, bool inv = false);
    void begin();
    bool isTriggered();
};