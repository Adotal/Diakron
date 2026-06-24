#include "pirSensor.h"
#include <Arduino.h>
PIRSensor::PIRSensor(IPinDriver &drv, uint8_t p, bool inv) : driver(drv), pin(p), inverted(inv)
{
}

void PIRSensor::begin()
{
    driver.pinMode(pin, INPUT);
}

bool PIRSensor::isTriggered()
{
    int value = driver.digitalRead(pin);
    return inverted ? (value == LOW) : (value == HIGH);
}

