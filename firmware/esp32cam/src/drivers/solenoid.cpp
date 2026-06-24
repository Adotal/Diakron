#include "solenoid.h"
#include <Arduino.h>
Solenoid::Solenoid(IPinDriver &driver, uint8_t pin) : driver(driver), pin(pin) {}

void Solenoid::begin()
{
    driver.pinMode(pin, OUTPUT);
    activate(); 
}

void Solenoid::activate()
{
    driver.digitalWrite(pin, HIGH);
}

void Solenoid::deactivate()
{
    driver.digitalWrite(pin, LOW);
}

bool Solenoid::isActive()
{
    return driver.digitalRead(pin) == HIGH;
}