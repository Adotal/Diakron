#pragma once

#include "../manager/container_manager.h"

class ContainerProtocol
{
private:

    ContainerManager &manager;

public:

    ContainerProtocol(ContainerManager &m);

    bool handleCommand(char *cmd);
};