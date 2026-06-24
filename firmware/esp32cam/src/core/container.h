#pragma once
#include "../drivers/solenoid.h"
#include "../drivers/limits.h"

/*
    This class is the combination between a solenoid and its limit switch to ensure how long the 
    lock should be open (until the limit switch is 0, meaning the can has been removed, 1 means 
    the can is in its position)
*/

class Container
{
private:

    Solenoid &lock;
    Limits &positionSwitch;

    bool unlocked = false;

public:

    Container(Solenoid &sLock, Limits &sw);

    void begin();

    void unlock();
    void lockContainer();

    void update();

    bool isUnlocked();
    bool isInserted();
};