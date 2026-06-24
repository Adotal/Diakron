#include "gearmotor.h"
#include <Arduino.h>
GearMotor::GearMotor(IPinDriver &driver, uint8_t pin1, uint8_t pin2) : driver(driver), pin1(pin1), pin2(pin2) {}

void GearMotor::begin() {
    driver.pinMode(pin1, OUTPUT);
    driver.pinMode(pin2, OUTPUT);
    stop();
}

void GearMotor::forward() {
    driver.digitalWrite(pin1, HIGH);
    driver.digitalWrite(pin2, LOW);
}

void GearMotor::backward() {
    driver.digitalWrite(pin1, LOW);
    driver.digitalWrite(pin2, HIGH);
}

void GearMotor::stop() {
    driver.digitalWrite(pin1, LOW);
    driver.digitalWrite(pin2, LOW);
}

