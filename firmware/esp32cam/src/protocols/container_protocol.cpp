#include "container_protocol.h"
#include <cstring>

ContainerProtocol::ContainerProtocol(
    ContainerManager &m
) :
manager(m)
{
}

bool ContainerProtocol::handleCommand(char *cmd)
{
    /*
        OPEN:M
        CLOSE:P
    */

    if(strncmp(cmd, "OPEN:", 5) == 0)
    {
        char id = cmd[5];

        manager.unlock(id);

        return true;
    }

    if(strncmp(cmd, "CLOSE:", 6) == 0)
    {
        char id = cmd[6];

        manager.lock(id);

        return true;
    }

    return false;
}