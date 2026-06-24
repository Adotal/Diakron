#pragma once
#include "../hal/IPinDriver.h"

class Solenoid
{
private:
    IPinDriver &driver;
    uint8_t pin;
public:
    Solenoid(IPinDriver &driver, uint8_t pin);
    void begin();
    void activate();
    void deactivate();
    bool isActive();
};