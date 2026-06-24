#pragma once
#include "../drivers/gearmotor.h"
#include "../drivers/infraredSensor.h"
#include "../drivers/limits.h"

/*
    This class is for intelligently managing the waste inlet door, 
    which is controlled by a DC motor and a pair of limit switches to determine if it is open or closed. 
    If anything interrupts the infrared signal, the door will not be able to close.
*/

enum class DoorState
{
    CLOSED_DOOR,
    OPENING_DOOR,
    OPEN_DOOR,
    CLOSING_DOOR,
    BLOCKED_DOOR
};

class Door
{
private:

    GearMotor &motor;

    Limits &openLimit;
    Limits &closeLimit;

    InfraredSensor &irSensor;

    DoorState state;

public:

    Door(
        GearMotor &m,
        Limits &openSw,
        Limits &closeSw,
        InfraredSensor &ir
    );

    void begin();

    void update();

    void open();
    void close();
    void stop();

    DoorState getState();

    bool isOpened();
    bool isClosed();
    bool isBlocked();
};