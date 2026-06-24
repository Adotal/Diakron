#pragma once
#include "../hal/IPinDriver.h"

class GearMotor{
private:
    IPinDriver &driver;
    uint8_t pin1, pin2;
public:
    GearMotor(IPinDriver &driver, uint8_t pin1, uint8_t pin2);
    void begin();
    void forward();
    void backward();
    void stop();

};