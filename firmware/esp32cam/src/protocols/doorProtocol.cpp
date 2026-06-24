#include "doorProtocol.h"
#include "../communication/logger.h"

#include <cstring>

DoorProtocol::DoorProtocol(Door &d)
    : door(d)
{
}

bool DoorProtocol::handleCommand(char *cmd)
{
    if(strcmp(cmd, "DOOR:OPEN") == 0)
    {
        Logger::info("DOOR OPEN");

        door.open();

        return true;
    }

    if(strcmp(cmd, "DOOR:CLOSE") == 0)
    {
        Logger::info("DOOR CLOSE");

        door.close();

        return true;
    }

    if(strcmp(cmd, "DOOR:STOP") == 0)
    {
        Logger::info("DOOR STOP");

        door.stop();

        return true;
    }

    if(strcmp(cmd, "DOOR:STATUS") == 0)
    {
        DoorState state = door.getState();

        switch(state)
        {
            case DoorState::OPEN_DOOR:
                Logger::info("DOOR STATE: OPEN");
                break;

            case DoorState::OPENING_DOOR:
                Logger::info("DOOR STATE: OPENING");
                break;

            case DoorState::CLOSED_DOOR:
                Logger::info("DOOR STATE: CLOSED");
                break;

            case DoorState::CLOSING_DOOR:
                Logger::info("DOOR STATE: CLOSING");
                break;

            case DoorState::BLOCKED_DOOR:
                Logger::info("DOOR STATE: BLOCKED");
                break;
        }

        return true;
    }

    return false;
}