#include "door.h"

Door::Door(
    GearMotor &m,
    Limits &openSw,
    Limits &closeSw,
    InfraredSensor &ir
) :
motor(m),
openLimit(openSw),
closeLimit(closeSw),
irSensor(ir),
state(DoorState::CLOSED_DOOR)
{
}

void Door::begin()
{
    motor.begin();

    openLimit.begin();
    closeLimit.begin();

    irSensor.begin();

    stop();

    if(!closeLimit.isTriggered() && !openLimit.isTriggered())
        state = DoorState::OPEN_DOOR;
    else if(openLimit.isTriggered())
        state = DoorState::OPEN_DOOR;
    else if(closeLimit.isTriggered())
        state = DoorState::CLOSED_DOOR;
}

void Door::open()
{
    if(state == DoorState::OPEN_DOOR)
        return;

    motor.forward();

    state = DoorState::OPENING_DOOR;
}

void Door::close()
{
    /*
        If IR detects something,
        do not close.
    */

    if(irSensor.isTriggered())
    {
        state = DoorState::BLOCKED_DOOR;
        return;
    }

    motor.backward();

    state = DoorState::CLOSING_DOOR;
}

void Door::stop()
{
    motor.stop();
}

void Door::update()
{
    switch(state)
    {
        case DoorState::OPENING_DOOR:

            if(openLimit.isTriggered())
            {
                stop();

                state = DoorState::OPEN_DOOR;
            }

            break;

        case DoorState::CLOSING_DOOR:

            /*
                Safety:
                if something crosses the IR,
                reopen door.
            */

            if(irSensor.isTriggered())
            {
                stop();

                open();

                state = DoorState::BLOCKED_DOOR;

                return;
            }

            if(closeLimit.isTriggered())
            {
                stop();

                state = DoorState::CLOSED_DOOR;
            }

            break;

        case DoorState::BLOCKED_DOOR:

            /*
                Wait until IR is clear,
                then keep opening.
            */

            if(openLimit.isTriggered())
            {
                stop();

                state = DoorState::OPEN_DOOR;
            }

            break;

        default:
            break;
    }
}

DoorState Door::getState()
{
    return state;
}

bool Door::isOpened()
{
    return state == DoorState::OPEN_DOOR;
}

bool Door::isClosed()
{
    return state == DoorState::CLOSED_DOOR;
}

bool Door::isBlocked()
{
    return irSensor.isTriggered();
}