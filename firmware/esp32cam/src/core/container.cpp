#include "container.h"

Container::Container(
    Solenoid &sLock,
    Limits &sw
) :
lock(sLock),
positionSwitch(sw)
{
}

void Container::begin()
{
    lock.begin();
    positionSwitch.begin();

    lockContainer();
}

void Container::unlock()
{
    unlocked = true;

    lock.activate();
}

void Container::lockContainer()
{
    unlocked = false;

    lock.deactivate();
}

void Container::update()
{
    /*
        If the container was unlocked and
        it was inserted again, lock it.
    */

    if(unlocked && isInserted())
    {
        lockContainer();
    }
}

bool Container::isUnlocked()
{
    return unlocked;
}

bool Container::isInserted()
{
    return positionSwitch.isTriggered();
}