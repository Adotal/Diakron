#pragma once

#include <Arduino.h>
#include <Ed25519.h>
#include "../services/websocket_service.h"

#define QR_PAYLOAD_SIZE 90
#define QR_PAYLOAD_COLLECTOR_SIZE 78

/* This strcuture is made to overlay on byteArrayQR() and write on it
   in a fast-redable way (before I used directy pointers to the array
   but it's kind of unsafe and not so redable)
   The __attribute__((packed)) is to instruct the compiler to minimize
   the memmory occupied by the structure by removing
   padding bytes between data, on the right are array's indexes
*/
typedef struct __attribute__((packed))
{

    uint8_t id[2];              // 0
    uint8_t countMetal;         // 2
    uint8_t weightMetal[2];     // 3
    uint8_t countPlastic;       // 5
    uint8_t weightPlastic[2];   // 6
    uint8_t countCardPaper;     // 8
    uint8_t weightCardPaper[2]; // 9
    uint8_t countGlass;         // 11
    uint8_t weightGlass[2];     // 12
    uint8_t timestamp[4];       // 14-17
    uint8_t nonce[8];           // 18-26
    uint8_t signature[64];      // 26–90 (ED25519)

} qr_payload_t;

/*
    This other structure is intented for collectors auth QR,
    which need less space then the participant qr_payload_t,
    as we can only perfom one action at time between
    showing QR of participant or showing QR of collector,
    the same space in memory (uint8_t payloadBuffer[]) is used
    Collector needs XX bytes:

        ID          - 2 BYTES
        Timestamp	- 4 BYTES
        Nonce		- 8 BYTES
        Firm		- 64 BYTES
        --------------------------
        TOTAL		- 78 BYTES

*/
typedef struct __attribute__((packed))
{

    uint8_t id[2];              // 0
    uint8_t timestamp[4];       // 2-6
    uint8_t nonce[8];           // 6-14
    uint8_t signature[64];      // 14-78 (ED25519)

} qr_payload_col_t;

class QRService
{
private:
    /*	This array stores the information of trash thrown to show a QR in the
        HMI, so the user can earn points.
        Each cell stores 8 bits, 0-255 DEC.
        Structure (below are the indexes):
        [id][M][WM][P][WP][C][CW][G][GW][Timestamp][Nonce][Firm ED25516]
        0    2  3   5  6  8  9   11  13  15     17  18 25  26        89
        M, P, C, G are the count of Metal, Plastic, Cardboard/Paper and Glass
        respectively, detected by the Segregator (Diakron),
        and MW, PW, CW, GW stands for WeightMetal, WeightPlastic,
        WeightCardPaper and WeightGlass

        ID          - 2 BYTES
        Metal		- 1 BYTE
        WeightM		- 2 BYTES
        Plastic		- 1 BYTE
        WeightP		- 2 BYTES
        Card-Paper	- 1 BYTE
        WeightC		- 2 BYTES
        Glass		- 1 BYTE
        WeightG		- 2 BYTES
        Timestamp	- 4 BYTES
        Nonce		- 8 BYTES
        Firm		- 64 BYTES
        --------------------------
        TOTAL		- 90 BYTES
    */
    uint8_t payloadBuffer[QR_PAYLOAD_SIZE];

    qr_payload_t *payload;
    qr_payload_col_t *payloadCollector;
    uint8_t publicKey[32];
    const uint8_t *privateKey;
    const uint16_t *idPointer;
    time_t getTime();

public:
    QRService(const uint16_t *idPointer, const uint8_t *privKey);

    void begin();

    void addMetal(uint16_t weight);
    void addPlastic(uint16_t weight);
    void addPaper(uint16_t weight);
    void addGlass(uint16_t weight);

    void build();
    void buildCollector();

    void send(WebSocketService &ws);
    void sendCollector(WebSocketService &ws);

    void clear();
};