#include "infraredSensor.h"
#include <Arduino.h>

InfraredSensor::InfraredSensor(IPinDriver &drv, uint8_t p, bool inv) : driver(drv), pin(p), inverted(inv) {}

void InfraredSensor::begin(){
    driver.pinMode(pin, INPUT_PULLUP);
}

bool InfraredSensor::isTriggered() {
    bool state = driver.digitalRead(pin);
    return inverted ? !state : state;
}