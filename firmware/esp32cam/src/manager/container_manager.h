#pragma once

#include "../core/container.h"
#include "../config/defaults.h"

class ContainerManager
{
private:

    struct ContainerNode
    {
        char id;
        Container *container;
    };

    ContainerNode containers[MAX_CONTAINERS];

    uint8_t count = 0;

public:

    bool addContainer(char id, Container *container);

    Container* getContainer(char id);

    void unlock(char id);

    void lock(char id);

    void update();

    void printStatus();
};