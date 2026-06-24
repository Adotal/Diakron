#include "qr_service.h"
#include "../communication/logger.h"
QRService::QRService(const uint16_t *idPointer, const uint8_t *privKey)
{
    this->idPointer = idPointer;
    privateKey = privKey;
    payload = (qr_payload_t *)payloadBuffer;
    payloadCollector = (qr_payload_col_t *)payloadBuffer;
}

void QRService::begin()
{
    clear();

    uint8_t pub[32] =
        {
            0x91, 0x96, 0x0d, 0x0c,
            0x77, 0x1c, 0x93, 0xe6,
            0x66, 0xc0, 0x73, 0x43,
            0x6f, 0x1b, 0xb3, 0xcf,
            0x0c, 0xc2, 0x32, 0x4e,
            0xe9, 0x82, 0xd8, 0xdf,
            0xf6, 0xf2, 0x86, 0x49,
            0xb8, 0x9b, 0xea, 0x3c};

    memcpy(publicKey, pub, 32);
}

void QRService::addMetal(uint16_t weight)
{
    payload->countMetal++;

    if (weight == 0)
    {
        weight = 1;
    }

    payload->weightMetal[0] = weight >> 8;
    payload->weightMetal[1] = weight;
}

void QRService::addPlastic(uint16_t weight)
{
    payload->countPlastic++;
    if (weight == 0)
    {
        weight = 1;
    }
    payload->weightPlastic[0] = weight >> 8;
    payload->weightPlastic[1] = weight;
}

void QRService::addPaper(uint16_t weight)
{
    payload->countCardPaper++;
    if (weight == 0)
    {
        weight = 1;
    }
    payload->weightCardPaper[0] = weight >> 8;
    payload->weightCardPaper[1] = weight;
}

void QRService::addGlass(uint16_t weight)
{
    payload->countGlass++;
    if (weight == 0)
    {
        weight = 1;
    }
    payload->weightGlass[0] = weight >> 8;
    payload->weightGlass[1] = weight;
}

/*
    Build QR payload, sign it and send it to websocket
    QR structure is defined higher in code, but as a small reminder:
    [id][Metal][Plastic][Paper/Cardboard][Glass][Timestamp][Nonce][ED25519SIGN]
*/
void QRService::build()
{
    // Add segregator id
    payload->id[0] = (uint8_t)(*idPointer >> 8);
    payload->id[1] = (uint8_t)(*idPointer);

    // Syncronize clock
    uint32_t tmp_millis;
    do
    {
        tmp_millis = getTime();
    } while (tmp_millis < 1000000);

    // Saving the number with LSB as MSB like twisting Endianess
    payload->timestamp[0] = (uint8_t)(tmp_millis >> 24);
    payload->timestamp[1] = (uint8_t)(tmp_millis >> 16);
    payload->timestamp[2] = (uint8_t)(tmp_millis >> 8);
    payload->timestamp[3] = (uint8_t)(tmp_millis);

    esp_fill_random(payload->nonce, sizeof(payload->nonce));

    Ed25519::sign(
        payload->signature,
        privateKey,
        publicKey,
        payloadBuffer,
        QR_PAYLOAD_SIZE - 64);

    // TESTING

    Serial.println(" ");
    for (int i = 0; i < QR_PAYLOAD_SIZE; i++)
    {
        Serial.print(payloadBuffer[i], HEX);
        Serial.print(" ");
    }
    Serial.println(" ");
}

/*
    Build QR payloadCollector, sign it and send it to websocket
    QR structure is defined higher in code, but as a small reminder:
    [id][Timestamp][Nonce][ED25519SIGN]
*/
void QRService::buildCollector()
{
    // Add segregator id
    payloadCollector->id[0] = (uint8_t)(*idPointer >> 8);
    payloadCollector->id[1] = (uint8_t)(*idPointer);

    // Syncronize clock
    uint32_t tmp_millis;
    do
    {
        tmp_millis = getTime();
    } while (tmp_millis < 1000000);

    // Saving the number with LSB as MSB like twisting Endianess
    payloadCollector->timestamp[0] = (uint8_t)(tmp_millis >> 24);
    payloadCollector->timestamp[1] = (uint8_t)(tmp_millis >> 16);
    payloadCollector->timestamp[2] = (uint8_t)(tmp_millis >> 8);
    payloadCollector->timestamp[3] = (uint8_t)(tmp_millis);

    esp_fill_random(payloadCollector->nonce, sizeof(payloadCollector->nonce));

    Ed25519::sign(
        payloadCollector->signature,
        privateKey,
        publicKey,
        payloadBuffer,
        QR_PAYLOAD_COLLECTOR_SIZE - 64);

    // TESTING

    Serial.println(" BUILT COLLECTOR QR");
    for (int i = 0; i < QR_PAYLOAD_COLLECTOR_SIZE; i++)
    {
        Serial.print(payloadBuffer[i], HEX);
        Serial.print(" ");
    }
    Serial.println(" ");
}

void QRService::send(WebSocketService &ws)
{
    size_t totalSize = QR_PAYLOAD_SIZE + 2;

    uint8_t *packet =
        (uint8_t *)malloc(totalSize);

    if(packet == nullptr)
    {
        Logger::error("NO MEM FOR QR");
        return;
    }

    // HEADER
    packet[0] = 'Q';
    packet[1] = 'R';

    // PAYLOAD
    memcpy(
        packet + 2,
        payloadBuffer,
        QR_PAYLOAD_SIZE);

    ws.sendBinary(packet, totalSize);

    free(packet);
}

void QRService::sendCollector(WebSocketService &ws)
{
    size_t totalSize =
        QR_PAYLOAD_COLLECTOR_SIZE + 2;

    uint8_t *packet =
        (uint8_t *)malloc(totalSize);

    if(packet == nullptr)
    {
        Logger::error("NO MEM FOR COL QR");
        return;
    }

    packet[0] = 'Q';
    packet[1] = 'R';

    memcpy(
        packet + 2,
        payloadBuffer,
        QR_PAYLOAD_COLLECTOR_SIZE);

    ws.sendBinary(packet, totalSize);

    free(packet);
}

void QRService::clear()
{
    memset(payloadBuffer, 0, sizeof(payloadBuffer));
}

// Get current timestamp to gen QR
time_t QRService::getTime()
{
    time_t now;
    time(&now);

    if (now > 1000000)
    { // Verifica que ya se haya sincronizado
        Serial.print("Unix Timestamp: ");
        Serial.println(now); // Equivalente a Math.floor(Date.now() / 1000)
    }
    else
    {
        Serial.println("Sincronizando hora...");
        vTaskDelay(50 / portTICK_PERIOD_MS);
    }
    return now;
}