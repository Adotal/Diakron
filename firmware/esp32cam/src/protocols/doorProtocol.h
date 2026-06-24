#pragma once

#include "../core/door.h"

class DoorProtocol
{
private:
    Door &door;

public:
    DoorProtocol(Door &d);

    /*
        Commands:

        DOOR:OPEN
        DOOR:CLOSE
        DOOR:STOP
        DOOR:STATUS
    */

    bool handleCommand(char *cmd);
};


