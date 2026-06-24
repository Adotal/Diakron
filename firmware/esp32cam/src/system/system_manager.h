#pragma once
#include <ESP32Servo.h>
#include "../config/defaults.h"
#include "../manager/motor_manager.h"
#include "../communication/command_router.h"
#include "system_controller.h"
#include "../core/interfaceUI.h"
#include "../services/camera_service.h"
#include "../manager/fill_level_manager.h"
#include "../services/websocket_service.h"
#include "../services/qr_service.h"
#include "../manager/sensor_manager.h"
#include "../drivers/hx711Sensor.h"
#include "../manager/container_manager.h"
#include "../drivers/pirSensor.h"
#include "../core/door.h"
class SystemManager
{
private:
    MotorManager& motorManager;
    CommandRouter& router;
    SystemController &controller;
    InterfaceUI &display;
    CameraService& camera;
    FillLevelManager& fillLevelManager;
    WebSocketService& wsService;
    QRService& qrService;
    SensorManager& sensorManager;
    HX711Sensor& sensorHX711;
    ContainerManager& containerManager;
    PIRSensor& pirSensor;
    Door& door;
    Servo& dumpServo;
    bool releasingTrash = false;
    unsigned long releaseStartTime = 0;

    static const uint16_t RELEASE_TIME = 3000;
    static const uint16_t RETURN_SERVO_TIME = 500;
    int sessionCount = 0;
    void processSegregation(const String& prediction);

    unsigned long insertWaitStart = 0;
    unsigned long pirDetectTime = 0;
    static const uint16_t INSERT_TIMEOUT = 5000;
    static const uint16_t PIR_TIMEOUT = 3000;

    uint8_t captureRetries = 0;

    static const uint8_t MAX_CAPTURE_RETRIES = 5;

    unsigned long captureRetryTimer = 0;
    bool pirLocked = false;
    bool collectionSessionActive = false;
    bool waitingForQR = false;
    
public:
    SystemManager(MotorManager& mm, CommandRouter& r, SystemController& sc, InterfaceUI& ui, 
        CameraService& cam, FillLevelManager& fm, WebSocketService& ws, QRService& qr, SensorManager& sm, 
        HX711Sensor& hx, ContainerManager& cm, PIRSensor& p, Door& d, Servo& servo);

    void init();
    void update();
    void processCommand(char* cmd);
    void handleInit();
    void handleExternalCommand(const String& cmd);
    void handleIdle();
    void handleOpeningDoor();
    void handleWaitingClear();
    void handleClosingDoor();
    void handleCapturing();
    void moveToMetal();
    void moveToPlastic();
    void moveToPaper();
    void moveToGlass();
    void handleMoveToMetal();
    void handleMoveToPlastic();
    void handleMoveToPaper();
    void handleMoveToGlass();
    void handleReturningHome();
    void returnHome();
    void releaseTrash();
    void handleReleasingTrash();
    void handleWaitingInsert();
    void handleWaitingNextItem();
    SystemController& getController();
};