#include "status_protocol.h"
#include <Arduino.h>
#include <string.h>

StatusProtocol::StatusProtocol(SystemController& sc)
    : controller(sc)
{
}

bool StatusProtocol::handle(char* command)
{
    // ===== STATE =====
    if(strncmp(command, "STATE", 5) == 0)
    {
        switch(controller.getState())
        {
            case SystemState::INIT:    Logger::state("INIT"); break;
            case SystemState::IDLE:    Logger::state("IDLE"); break;
            case SystemState::OPENING_DOOR: Logger::state("OPENING_DOOR"); break;
            case SystemState::WAITING_CLEAR: Logger::state("WAITING_CLEAR"); break;
            case SystemState::CLOSING_DOOR: Logger::state("CLOSING_DOOR"); break;
            case SystemState::CAPTURING: Logger::state("CAPTURING");
            case SystemState::CLASSIFYING: Logger::state("CLASSIFYING"); break;
            case SystemState::MOVING_TO_METAL: Logger::state("MOVING_TO_METAL"); break;
            case SystemState::MOVING_TO_PLASTIC: Logger::state("MOVING_TO_PLASTIC"); break;
            case SystemState::MOVING_TO_PAPER: Logger::state("MOVING_TO_PAPER"); break;
            case SystemState::MOVING_TO_GLASS: Logger::state("MOVING_TO_GLASS"); break;
            case SystemState::RETURNING_HOME: Logger::state("RETURNING_HOME"); break;
            case SystemState::HOMING: Logger::state("HOMING"); break;
            case SystemState::RUNNING: Logger::state("RUNNING"); break;
            case SystemState::ERROR_STATE: Logger::state("ERROR_STATE"); break;
            case SystemState::RELEASING_TRASH: Logger::state("RELEASING_TRASH"); break;
            case SystemState::BOOT: Logger::state("BOOT"); break;
            case SystemState::ESTOP: Logger::state("ESTOP"); break;
            
        }
        return true;
    }

    // ===== SETSTATE =====
if(strncmp(command, "SETSTATE ", 9) == 0)
{
    const char* stateName = command + 9;

    if(strcmp(stateName, "INIT") == 0)
        controller.setState(SystemState::INIT);

    else if(strcmp(stateName, "IDLE") == 0)
        controller.setState(SystemState::IDLE);

    else if(strcmp(stateName, "OPENING_DOOR") == 0)
        controller.setState(SystemState::OPENING_DOOR);

    else if(strcmp(stateName, "WAITING_CLEAR") == 0)
        controller.setState(SystemState::WAITING_CLEAR);

    else if(strcmp(stateName, "CLOSING_DOOR") == 0)
        controller.setState(SystemState::CLOSING_DOOR);

    else if(strcmp(stateName, "CAPTURING") == 0)
        controller.setState(SystemState::CAPTURING);

    else if(strcmp(stateName, "CLASSIFYING") == 0)
        controller.setState(SystemState::CLASSIFYING);

    else if(strcmp(stateName, "MOVING_TO_METAL") == 0)
        controller.setState(SystemState::MOVING_TO_METAL);

    else if(strcmp(stateName, "MOVING_TO_PLASTIC") == 0)
        controller.setState(SystemState::MOVING_TO_PLASTIC);

    else if(strcmp(stateName, "MOVING_TO_PAPER") == 0)
        controller.setState(SystemState::MOVING_TO_PAPER);

    else if(strcmp(stateName, "MOVING_TO_GLASS") == 0)
        controller.setState(SystemState::MOVING_TO_GLASS);

    else if(strcmp(stateName, "RETURNING_HOME") == 0)
        controller.setState(SystemState::RETURNING_HOME);

    else if(strcmp(stateName, "HOMING") == 0)
        controller.setState(SystemState::HOMING);

    else if(strcmp(stateName, "RUNNING") == 0)
        controller.setState(SystemState::RUNNING);

    else if(strcmp(stateName, "ERROR_STATE") == 0)
        controller.setState(SystemState::ERROR_STATE);

    else if(strcmp(stateName, "RELEASING_TRASH") == 0)
        controller.setState(SystemState::RELEASING_TRASH);

    else if(strcmp(stateName, "BOOT") == 0)
        controller.setState(SystemState::BOOT);

    else if(strcmp(stateName, "ESTOP") == 0)
        controller.setState(SystemState::ESTOP);

    else
    {
        Logger::error("INVALID STATE");
        return true;
    }

    Logger::info(
        (String("STATE CHANGED TO ") + stateName).c_str()
    );

    return true;
}

    return false;
}