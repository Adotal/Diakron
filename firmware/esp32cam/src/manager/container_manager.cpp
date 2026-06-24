#include "container_manager.h"
#include "../communication/logger.h"

bool ContainerManager::addContainer(
    char id,
    Container *container
)
{
    if(count >= MAX_CONTAINERS)
        return false;

    containers[count++] = {id, container};

    return true;
}

Container* ContainerManager::getContainer(char id)
{
    for(uint8_t i = 0; i < count; i++)
    {
        if(containers[i].id == id)
            return containers[i].container;
    }

    return nullptr;
}

void ContainerManager::unlock(char id)
{
    Container *container = getContainer(id);

    if(container)
        container->unlock();
}

void ContainerManager::lock(char id)
{
    Container *container = getContainer(id);

    if(container)
        container->lockContainer();
}

void ContainerManager::update()
{
    for(uint8_t i = 0; i < count; i++)
    {
        containers[i].container->update();
    }
}

void ContainerManager::printStatus()
{
    for(uint8_t i = 0; i < count; i++)
    {
        Container *c = containers[i].container;

        String msg =
            "Container ";

        msg += containers[i].id;

        msg += " inserted: ";

        msg += c->isInserted()
            ? "YES"
            : "NO";

        Logger::info(msg.c_str());
    }
}