#include "fill_level_manager.h"

void FillLevelManager::addSensor(HCSR04Sensor* sensor)
{
    if(count < MAX_BINS)
    {
        sensors[count++] = sensor;
    }
}

uint8_t FillLevelManager::getFillPercentage(uint8_t index)
{
    if(index >= count) return 0;

    uint32_t sum = 0;

    for(int i = 0; i < 3; i++)
    {
        sum += sensors[index]->readDistance();

        delay(30);
    }

    uint16_t avg = sum / 3;

    // profundidad máxima del bote (cm)
    uint16_t depth = 60;

    uint8_t percent =
        100 - ((avg * 100) / depth);

    percent = constrain(percent, 0, 100);

    return percent;
}

void FillLevelManager::buildPayload(uint8_t* buffer)
{
    buffer[0] = 'F';
    buffer[1] = 'L';

    for(uint8_t i = 0; i < count; i++)
    {
        buffer[i+2] = getFillPercentage(i);
    }
}

void FillLevelManager::sendLevels(WebSocketService& ws)
{
    uint8_t fillLevels[6];

    fillLevels[0] = 'F';
    fillLevels[1] = 'L';

    const char* names[] =
    {
        "METAL",
        "PLASTIC",
        "PAPER",
        "GLASS"
    };

    for (int i = 0; i < count; i++)
    {
        uint16_t distance =
            sensors[i]->readDistance();

        uint8_t percent =
            100 - ((distance * 100) / 60);

        percent = constrain(percent, 0, 100);

        fillLevels[i + 2] = percent;

        String logMsg =
            String(names[i]) +
            " DIST=" +
            String(distance) +
            "cm FILL=" +
            String(percent) +
            "%";

        Logger::info(logMsg.c_str());

        delay(80);
    }

    ws.sendBinary(
        fillLevels,
        sizeof(fillLevels));
}