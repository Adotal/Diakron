#include "command_router.h"

CommandRouter::CommandRouter(MotionProtocol& mp, StatusProtocol& sp, SensorProtocol& senp, CalibrationProtocol& calp, ContainerProtocol& contp, DoorProtocol& doorp)
: motion(mp), status(sp), sensor(senp), calibration(calp), container(contp), door(doorp)
{
}

bool CommandRouter::route(char* command)
{
    if(motion.handle(command)) return true;
    if(status.handle(command)) return true;
    if(sensor.handle(command)) return true;
    if(calibration.handle(command)) return true;
    if(container.handleCommand(command)) return true;
    if(door.handleCommand(command)) return true;
    return false;
}