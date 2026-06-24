#include "hcsr04_sensor.h"
#include <Arduino.h>
HCSR04Sensor::HCSR04Sensor(IPinDriver& driver, uint8_t trig, uint8_t echo, uint16_t maxDist)
    : driver(driver), trigPin(trig), echoPin(echo), maxDistanceCm(maxDist)
{}

void HCSR04Sensor::begin()
{
    driver.pinMode(trigPin, OUTPUT);
    driver.pinMode(echoPin, INPUT);
    driver.digitalWrite(trigPin, LOW);
}

uint16_t HCSR04Sensor::readDistance()
{
    uint32_t readings[5];

    for(int i = 0; i < 5; i++)
    {
        driver.digitalWrite(trigPin, LOW);
        delayMicroseconds(2);

        driver.digitalWrite(trigPin, HIGH);
        delayMicroseconds(10);

        driver.digitalWrite(trigPin, LOW);

        unsigned long duration =
            driver.pulseIn(
                echoPin,
                HIGH,
                40000UL);

        if(duration == 0)
        {
            readings[i] = maxDistanceCm;
        }
        else
        {
            readings[i] = duration / 58;
        }

        delay(30);
    }

    // SORT

    for(int i = 0; i < 5; i++)
    {
        for(int j = i + 1; j < 5; j++)
        {
            if(readings[j] < readings[i])
            {
                uint32_t t = readings[i];
                readings[i] = readings[j];
                readings[j] = t;
            }
        }
    }

    uint16_t distance = readings[2];

    if(distance > maxDistanceCm)
        distance = maxDistanceCm;

    return distance;
} 

uint8_t HCSR04Sensor::getFillPercentage()
{
    uint16_t distance = readDistance();

    if (distance > maxDistanceCm)
        distance = maxDistanceCm;

    return 100 - (distance * 100 / maxDistanceCm);
}