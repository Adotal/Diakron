#include "axis.h"
#include "../communication/logger.h"
axis::axis(motor &motorType, Limits &sw, long maxTravel, bool inverted) : motorRef(motorType), homeSwitch(sw), maxTravelSteps(maxTravel), isInverted(inverted)
{
    state = HOMING_IDLE;
    measuredMaxSteps = 0;
    isInverted = inverted;
    targetPosition = 0;
    isMoving = false;
    homingEnabled = true;
}

void axis::startHoming()
{
    motorRef.enable(true);

    motorRef.setDirection(isInverted);

    motorRef.setSpeed(HOMING_FAST_RPM);

    state = HOMING_FAST_SEEK;
}

void axis::updateHoming()
{
    switch(state)
    {
    case HOMING_FAST_SEEK:

        if(!homeSwitch.isTriggered())
        {
            motorRef.update();
        }
        else
        {
            Logger::info("FAST_SEEK -> BACKOFF");

            motorRef.setDirection(!isInverted);
            motorRef.setSpeed(HOMING_FAST_RPM);

            state = HOMING_BACKOFF;
        }

        break;

    case HOMING_BACKOFF:

        if(homeSwitch.isTriggered())
        {
            motorRef.update();
        }
        else
        {
            Logger::info("BACKOFF -> SLOW_SEEK");

            motorRef.setDirection(isInverted);
            motorRef.setSpeed(HOMING_SLOW_RPM);

            state = HOMING_SLOW_SEEK;
        }

        break;

    case HOMING_SLOW_SEEK:

        if(!homeSwitch.isTriggered())
        {
            motorRef.update();
        }
        else
        {
            Logger::info("SLOW_SEEK -> SET_ZERO");

            state = HOMING_SET_ZERO;
        }

        break;

    case HOMING_SET_ZERO:

        Logger::info("SET_ZERO");

        motorRef.resetPosition(0);

        motorRef.setDirection(!isInverted);

        motorRef.setSpeed(HOMING_SLOW_RPM);

        state = HOMING_SAFETY_PULL_OFF;

        break;

    case HOMING_SAFETY_PULL_OFF:

        if(abs(motorRef.getPosition()) < SAFETY_STEPS)
        {
            motorRef.update();
        }
        else
        {
            Logger::info("HOMING_DONE");

            motorRef.enable(false);

            measuredMaxSteps = maxTravelSteps;

            state = HOMING_DONE;
        }

        break;

    case HOMING_DONE:
        motorRef.enable(false);
        break;

    case HOMING_ERROR:
        motorRef.enable(false);
        break;

    default:
        break;
    }
}

bool axis::isHomed() const
{
    return state == HOMING_DONE;
}

bool axis::isMoved() const
{
    return isMoving;
}

long axis::getMeasuredMax() const
{
    return measuredMaxSteps;
}

long axis::dynamicSpeed(int percentage)
{
    // This function can be implemented to adjust the speed based on the distance to the target position
    // For example, you can reduce the speed as it gets closer to the target to avoid overshooting
    // This is just a placeholder implementation and can be adjusted based on the specific requirements of your application
    return (((motorRef.getDefaultRPM() + motorRef.getMaxRPM()) / 2) * percentage) / 100;
}

bool axis::moveTo(long target)
{
    // SOLO aplicar límites si homing está activo
    if (homingEnabled)
    {
        if (target < 0)
            target = 0;

        if (target > measuredMaxSteps)
            target = measuredMaxSteps;
    }

    long current = motorRef.getPosition();

    if (target == current)
        return true;

    motorRef.setDirection(target > current);

    motorRef.setSpeed(motorRef.getDefaultRPM());

    targetPosition = target;

    isMoving = true;

    return true;
}

bool axis::moveRelative(long delta)
{
    return moveTo(motorRef.getPosition() + delta);
}

void axis::update()
{
    // SOLO ejecutar homing si está habilitado
    if (homingEnabled && !isHomed())
    {
        updateHoming();
        return;
    }

    if (isMoving)
    {
        motorRef.enable(true);

        long pos = motorRef.getPosition();

        if (pos == targetPosition)
        {
            isMoving = false;

            motorRef.enable(false);

            return;
        }

        motorRef.update();
    }
}
void axis::setHomingEnabled(bool enabled)
{
    homingEnabled = enabled;

    if (!enabled)
    {
        state = HOMING_DONE;
    }
}

bool axis::isHomingEnabled() const
{
    return homingEnabled;
}

long axis::getCurrentPosition() const
{
    return motorRef.getPosition();
}

void axis::stopHoming()
{
    motorRef.enable(false);

    isMoving = false;

    state = HOMING_IDLE;
}