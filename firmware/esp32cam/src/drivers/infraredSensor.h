#pragma once
#include "../hal/IPinDriver.h"

class InfraredSensor
{
private:
    IPinDriver &driver;
    uint8_t pin;
    bool inverted;
public:
    InfraredSensor(IPinDriver &drv, uint8_t p, bool inv = false);
    void begin();
    bool isTriggered();
};