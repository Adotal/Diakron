#include "system_manager.h"

extern bool mcp1_ok;
extern bool mcp2_ok;
extern bool mcp3_ok;

SystemManager::SystemManager(
    MotorManager &mm,
    CommandRouter &r,
    SystemController &sc,
    InterfaceUI &ui,
    CameraService &cam,
    FillLevelManager &fm,
    WebSocketService &wsm,
    QRService &qr,
    SensorManager &sm,
    HX711Sensor &hx,
    ContainerManager &cm,
    PIRSensor &p,
    Door &d,
    Servo &servo)
    : motorManager(mm),
      router(r),
      controller(sc),
      display(ui),
      camera(cam),
      fillLevelManager(fm),
      wsService(wsm),
      qrService(qr),
      sensorManager(sm),
      sensorHX711(hx),
      containerManager(cm),
      pirSensor(p),
      door(d),
      dumpServo(servo)
{
}

void SystemManager::init()
{

    Logger::info("Initializing SystemManager...");
    controller.setState(SystemState::IDLE);
}

void SystemManager::update()
{
    motorManager.update();
    containerManager.update();
    door.update();

    SystemState state = controller.getState();

    switch (state)
    {
    case SystemState::IDLE:
        handleIdle();
        break;

    case SystemState::OPENING_DOOR:
        handleOpeningDoor();
        break;

    case SystemState::WAITING_INSERT:
        handleWaitingInsert();
        break;

    case SystemState::WAITING_CLEAR:
        handleWaitingClear();
        break;

    case SystemState::CLOSING_DOOR:
        handleClosingDoor();
        break;
    case SystemState::WAITING_NEXT_ITEM:
        handleWaitingNextItem();
        break;
    case SystemState::CAPTURING:
        handleCapturing();
        break;

    case SystemState::MOVING_TO_METAL:
        handleMoveToMetal();
        break;

    case SystemState::MOVING_TO_PLASTIC:
        handleMoveToPlastic();
        break;

    case SystemState::MOVING_TO_PAPER:
        handleMoveToPaper();
        break;

    case SystemState::MOVING_TO_GLASS:
        handleMoveToGlass();
        break;

    case SystemState::RETURNING_HOME:
        handleReturningHome();
        break;

    case SystemState::RELEASING_TRASH:
        handleReleasingTrash();
        break;

    case SystemState::HOMING:

        if (motorManager.allAxesHomed())
        {
            Logger::info("ALL HOMING COMPLETED");

            controller.setState(SystemState::IDLE);
        }
        break;

    default:
        break;
    }
}

/* =========================================================
                    SERIAL COMMANDS
========================================================= */

void SystemManager::processCommand(char *cmd)
{
    if (controller.isEstopped())
    {
        Logger::error("ESTOP ACTIVE");
        return;
    }
    if (!router.route(cmd))
    {
        Logger::error("INVALID COMMAND!");
    }
}

/* =========================================================
                    WEBSOCKET COMMANDS
========================================================= */

void SystemManager::handleExternalCommand(const String &cmd)
{
    // When manual capture command

    if (cmd == "CAPT")
    {
        Logger::info("MANUAL CAPTURE");
        captureRetries = 0;
        camera.requestCapture();
        controller.setState(SystemState::CAPTURING);
    }
    else if (cmd == "GET_QR")
    {
        qrService.build();
        qrService.send(wsService);
        qrService.clear();

        sessionCount = 0;

        Logger::info("QR SESSION SENT");

        waitingForQR = false;
        collectionSessionActive = false;
        pirLocked = true;
        door.close();

        controller.setState(SystemState::IDLE);
    }
    else if (cmd == "FL")
    {
        // When asked to send fill levels
        Logger::info("FILL LEVELS SENT");
        fillLevelManager.sendLevels(wsService);
    }
    else if (cmd == "COL")
    {
        // When the button "Soy recolector" is pressed
        qrService.buildCollector();
        qrService.sendCollector(wsService);
        qrService.clear();
        Logger::info("COLLECTOR QR SENT");
    }
    else if (cmd == "THROW")
    {
        Logger::info("Tilting Tray");
        dumpServo.write(180);
    }
    else if (cmd == "CATCH")
    {

        Logger::info("Picking up tray");
        dumpServo.write(0);
    }
    else if (cmd == "MCP")
    {
        String msg = "\n===== MCP STATUS =====\n";

        msg += "MCP 0x20 : ";
        msg += (mcp1_ok ? "OK\n" : "FAIL\n");

        msg += "MCP 0x21 : ";
        msg += (mcp2_ok ? "OK\n" : "FAIL\n");

        msg += "MCP 0x22 : ";
        msg += (mcp3_ok ? "OK\n" : "FAIL\n");

        Logger::info(msg.c_str());
    }
    else if (cmd == "TEST METAL")
    {
        moveToMetal();
        controller.setState(SystemState::MOVING_TO_METAL);
    }
    else if (cmd == "TEST PLASTIC")
    {
        moveToPlastic();
        controller.setState(SystemState::MOVING_TO_PLASTIC);
    }
    else if (cmd == "TEST PAPER")
    {
        moveToPaper();
        controller.setState(SystemState::MOVING_TO_PAPER);
    }
    else if (cmd == "TEST GLASS")
    {
        moveToGlass();
        controller.setState(SystemState::MOVING_TO_GLASS);
    }
    else
    {
        Logger::info(("REMOTE CMD: " + cmd).c_str());
        this->processCommand(const_cast<char *>(cmd.c_str()));
    }
}

/* =========================================================
                        MAIN STATES
========================================================= */

void SystemManager::handleIdle()
{
    display.update();

    if (collectionSessionActive)
        return;

    if (pirLocked)
    {
        if (!pirSensor.isTriggered())
        {
            Logger::info("PIR REARMED");
            pirLocked = false;
        }

        return;
    }

    if (pirSensor.isTriggered())
    {
        Logger::info("PERSON DETECTED");

        pirLocked = true;

        door.open();

        controller.setState(SystemState::OPENING_DOOR);
    }
}

void SystemManager::handleOpeningDoor()
{
    if (door.isOpened())
    {
        Logger::info("DOOR OPENED");

        insertWaitStart = millis();

        controller.setState(SystemState::WAITING_INSERT);
    }
}

void SystemManager::handleWaitingInsert()
{
    // The user's hand was detected
    if (door.isBlocked())
    {
        Logger::info("OBJECT DETECTED");

        collectionSessionActive = true;

        controller.setState(SystemState::WAITING_CLEAR);

        return;
    }

    // If no interruption is detected once the door is open, close it and do nothing.
    if (millis() - insertWaitStart >= INSERT_TIMEOUT)
    {
        Logger::info("INSERT TIMEOUT");

        door.close();

        controller.setState(SystemState::IDLE);
    }
}

void SystemManager::handleWaitingClear()
{
    /*
        If something is blocking IR,
        keep waiting.

        Once user removes hand/object,
        close the door.
    */

    if (!door.isBlocked())
    {
        Logger::info("OBJECT RELEASED");

        door.close();

        controller.setState(SystemState::CLOSING_DOOR);
    }
}

void SystemManager::handleClosingDoor()
{
    if (door.isBlocked())
    {
        Logger::info("OBJECT DETECTED DURING CLOSING");

        door.open();

        controller.setState(SystemState::WAITING_INSERT);

        return;
    }

    if (door.isClosed())
    {
        Logger::info("DOOR CLOSED");

        captureRetries = 0;

        camera.requestCapture();

        controller.setState(SystemState::CAPTURING);
    }
}

void SystemManager::handleWaitingNextItem()
{
    if (door.isBlocked())
    {
        Logger::info("NEW OBJECT DETECTED");

        controller.setState(SystemState::WAITING_CLEAR);
    }
}

void SystemManager::handleCapturing()
{
    // SUCCESS
    if (camera.hasNewResult())
    {

        String result = camera.getPrediction();

        Logger::info(("Prediction: " + result).c_str());

        captureRetries = 0;

        processSegregation(result);

        return;
    }

    // FAILURE
    if (camera.hasFailed())
    {
        camera.clearFailure();

        captureRetries++;

        Logger::error(
            ("CAPTURE FAILED RETRY: " +
             String(captureRetries))
                .c_str());

        if (captureRetries >= MAX_CAPTURE_RETRIES)
        {
            Logger::error("MAX RETRIES REACHED");

            wsService.sendText(
                "{\"type\":\"CAMERA_ERROR\"}");

            controller.setState(SystemState::IDLE);

            return;
        }

        // Espera pequeña antes de reintentar
        vTaskDelay(pdMS_TO_TICKS(1000));

        Logger::info("RETRYING CAPTURE");

        camera.requestCapture();
    }
}

/* =========================================================
                    SEGREGATION LOGIC
========================================================= */

void SystemManager::processSegregation(const String &prediction)
{
    bool inductive = sensorManager.readSensor('I');
    bool capacitive = sensorManager.readSensor('C');

    JsonDocument doc;
    String finalMaterial = "";

    DeserializationError error =
        deserializeJson(doc, prediction);

    if (error)
    {
        Logger::error("INVALID JSON");

        controller.setState(SystemState::RETURNING_HOME);

        return;
    }

    String material = doc["predicted"];

    uint16_t weight = sensorHX711.getWeight();

    if (inductive || material == "metal")
    {
        Logger::info("METAL");
        finalMaterial = "METAL";

        qrService.addMetal(weight);

        moveToMetal();

        controller.setState(SystemState::MOVING_TO_METAL);
    }

    else if (
        (capacitive && material == "glass") ||
        (capacitive && material == "plastic"))
    {
        Logger::info("GLASS");
        finalMaterial = "GLASS";

        qrService.addGlass(weight);

        moveToGlass();

        controller.setState(SystemState::MOVING_TO_GLASS);
    }

    else if (
        material == "plastic" ||
        (material == "glass" && !capacitive))
    {
        Logger::info("PLASTIC");
        finalMaterial = "PLASTIC";

        qrService.addPlastic(weight);

        moveToPlastic();

        controller.setState(SystemState::MOVING_TO_PLASTIC);
    }

    else if (
        material == "paper" ||
        material == "cardboard")
    {
        Logger::info("PAPER/CARDBOARD");
        finalMaterial = "PAPER/CARDBOARD";

        qrService.addPaper(weight);

        moveToPaper();

        controller.setState(SystemState::MOVING_TO_PAPER);
    }

    else
    {
        Logger::error("UNKNOWN MATERIAL");

        controller.setState(SystemState::RETURNING_HOME);

        return;
    }

    // SESSION UPDATE TO HMI

    sessionCount++;

    String msg =
        "{"
        "\"type\":\"SESSION_UPDATE\","
        "\"count\":" + String(sessionCount) + ","
        "\"material\":\"" + finalMaterial + "\""
        "}";

    wsService.sendText(msg);

    // Logger::info(msg.c_str());
}

/* =========================================================
                    MOVEMENT LOGIC
========================================================= */
void SystemManager::moveToMetal()
{
    Logger::info("MOVING TO METAL");

    axis *ax = motorManager.getAxis('H');

    if (ax)
    {
        ax->moveTo(POSITION_METAL);
    }
}

void SystemManager::moveToPlastic()
{
    Logger::info("MOVING TO PLASTIC");

    axis *ax = motorManager.getAxis('H');

    if (ax)
        ax->moveTo(POSITION_PLASTIC);
}

void SystemManager::moveToPaper()
{
    Logger::info("MOVING TO PAPER");

    axis *ax = motorManager.getAxis('H');

    if (ax)
        ax->moveTo(POSITION_PAPER);
}

void SystemManager::moveToGlass()
{
    Logger::info("MOVING TO GLASS");

    axis *ax = motorManager.getAxis('H');

    if (ax)
        ax->moveTo(POSITION_GLASS);
}

/* =========================================================
                WAIT FOR MOVEMENT COMPLETE
========================================================= */

void SystemManager::handleMoveToMetal()
{
    if (!motorManager.isAnyAxisMoving())
    {
        releaseTrash();

        controller.setState(SystemState::RELEASING_TRASH);
    }
}

void SystemManager::handleMoveToPlastic()
{
    if (!motorManager.isAnyAxisMoving())
    {
        releaseTrash();

        controller.setState(SystemState::RELEASING_TRASH);
    }
}

void SystemManager::handleMoveToPaper()
{
    if (!motorManager.isAnyAxisMoving())
    {
        releaseTrash();

        controller.setState(SystemState::RELEASING_TRASH);
    }
}

void SystemManager::handleMoveToGlass()
{
    if (!motorManager.isAnyAxisMoving())
    {
        releaseTrash();

        controller.setState(SystemState::RELEASING_TRASH);
    }
}

/* =========================================================
                    RETURN HOME
========================================================= */

void SystemManager::returnHome()
{
    Logger::info("RETURNING HOME");

    axis *ax = motorManager.getAxis('H');

    if (ax)
    {
        ax->startHoming();
    }
}

void SystemManager::handleReturningHome()
{
    if (!motorManager.isAnyAxisMoving())
    {
        Logger::info("READY FOR NEXT ITEM");

        door.open();

        waitingForQR = true;

        controller.setState(SystemState::WAITING_NEXT_ITEM);
    }
}

/* =========================================================
                    RELEASE TRASH
========================================================= */

void SystemManager::handleReleasingTrash()
{
    if (!releasingTrash)
        return;

    if (millis() - releaseStartTime >= RELEASE_TIME)
    {
        dumpServo.write(0);
        vTaskDelay(RETURN_SERVO_TIME / portTICK_PERIOD_MS);
        releasingTrash = false;

        Logger::info("TRASH RELEASE COMPLETE");

        returnHome();

        controller.setState(SystemState::RETURNING_HOME);
    }
}

void SystemManager::releaseTrash()
{
    Logger::info("RELEASING TRASH");

    dumpServo.write(180);

    releaseStartTime = millis();

    releasingTrash = true;
}

/* =========================================================
                    ACCESS
========================================================= */

SystemController &SystemManager::getController()
{
    return controller;
}