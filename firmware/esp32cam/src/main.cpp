// main.cpp
#include "main.h"

// -------------------------PIN DEFINITION & CONSTANTS--------------------------
#include "config/camera_pins.h"

// Compiler should write in memory SERVER_URL just once to save space
#define SERVER_URL "https://diakron-backend.onrender.com/"
const char *serverURL = SERVER_URL;
const char *backendURL = SERVER_URL "analyze";

// Private Key is a secret
extern const uint8_t private_key_start[] asm("_binary_secrets_private_key_ed25516_bin_start");
extern const uint8_t private_key_end[] asm("_binary_secrets_private_key_ed25516_bin_end");
// Define private key (its size is 32B)
const uint8_t *privateKey = private_key_start;
// ID del segregador
const uint16_t id = 1;

// =====================
// Services WIFI
// =====================
// NTP server to request epoch time
const char *ntpServer = "pool.ntp.org";
WifiService wifiService;
// =====================
// Services WEBSOCKET
// =====================
AsyncWebServer server(80);
WebSocketService wsService(server);
WebSocketsClient webSocketSrvr;
DebugWebService segregatorWeb(server);
// =====================
// Services Camera
// =====================
CameraService camera(backendURL);
// =====================
// Services QR
// =====================
QRService qrService(&id, privateKey);
// =====================
// System Controller
// =====================
SystemController sysController;

// =====================
// Interfaces
// =====================
Adafruit_MCP23X17 mcp, mcp2, mcp3;
mcp_driver interfaceI2C(mcp);	// 0x20
mcp_driver interfaceI2C2(mcp2); // 0x21
mcp_driver interfaceI2C3(mcp3); // 0x22
gpio_driver interfaceGPIO;

bool mcp1_ok = false;
bool mcp2_ok = false;
bool mcp3_ok = false;

// =====================
// Motors
// =====================
nema17 motorHead(interfaceI2C, HEAD_STEP_PIN, HEAD_DIR_PIN, HEAD_ENABLE_PIN);
stepper_28byj motorSensorINDU(interfaceI2C, INDU_STEP_PIN_1, INDU_STEP_PIN_2, INDU_STEP_PIN_3, INDU_STEP_PIN_4);
stepper_28byj motorSensorCAPC(interfaceI2C, CAPC_STEP_PIN_1, CAPC_STEP_PIN_2, CAPC_STEP_PIN_3, CAPC_STEP_PIN_4);
GearMotor gearmotor(interfaceI2C2, MOTOR_DOOR_PIN_IZQ, MOTOR_DOOR_PIN_DER);
Servo dumpServo;
// =====================
// Solenoids
// =====================
Solenoid solenoidBinMetal(interfaceI2C2, SOLENOID_LOCK_1);
Solenoid solenoidBinPlastic(interfaceI2C2, SOLENOID_LOCK_2);
Solenoid solenoidBinPaper(interfaceI2C2, SOLENOID_LOCK_3);
Solenoid solenoidBinGlass(interfaceI2C2, SOLENOID_LOCK_4);

// =====================
// Sensors
// =====================
CapacitiveSensor sensorCAPC(interfaceI2C, GPIO_CAPC);
InductiveSensor sensorINDU(interfaceI2C, GPIO_INDU);
HX711Sensor sensorHX711(HX711_DOUT_PIN, HX711_SCK_PIN);
HCSR04Sensor binMetal(interfaceI2C3, PCF_TRIG, binMetalEchoPin, binDepthCm);
HCSR04Sensor binPlastic(interfaceI2C3, PCF_TRIG, binPlasticEchoPin, binDepthCm);
HCSR04Sensor binPaper(interfaceI2C3, PCF_TRIG, binPaperEchoPin, binDepthCm);
HCSR04Sensor binGlass(interfaceI2C3, PCF_TRIG, binGlassEchoPin, binDepthCm);
InfraredSensor doorSensor(interfaceI2C2, DOOR_SENSOR_IR, true);
PIRSensor pirSensor(interfaceI2C3, PIR_SENSOR_PIN);
// =====================
// Limit switches
// =====================
Limits limitHead(interfaceI2C, LIMIT_HEAD_PIN, true);
Limits limitINDU(interfaceI2C, LIMIT_INDU_PIN, true);
Limits limitCAPC(interfaceI2C, LIMIT_CAPC_PIN, true);

Limits limitBinMetal(interfaceI2C2, LIMIT_SOLENOID_1, false);
Limits limitBinPlastic(interfaceI2C2, LIMIT_SOLENOID_2, false);
Limits limitBinPaper(interfaceI2C2, LIMIT_SOLENOID_3, false);
Limits limitBinGlass(interfaceI2C2, LIMIT_SOLENOID_4, false);

Limits limitDoor(interfaceI2C2, LIMIT_OPEN_DOOR, true);
Limits limitDoorClose(interfaceI2C2, LIMIT_CLOSE_DOOR, true);

// =====================
// Axis (motor + limit)
// =====================
axis axisHead(motorHead, limitHead, MAX_TRAVEL_STEPS_BASE, false);
axis axisINDU(motorSensorINDU, limitINDU, MAX_TRAVEL_STEPS_INDU, false);
axis axisCAPC(motorSensorCAPC, limitCAPC, MAX_TRAVEL_STEPS_CAPC, true);

// =====================
// Container (solenoid + limit)
// =====================
Container containerMetal(solenoidBinMetal, limitBinMetal);
Container containerPlastic(solenoidBinPlastic, limitBinPlastic);
Container containerPaper(solenoidBinPaper, limitBinPaper);
Container containerGlass(solenoidBinGlass, limitBinGlass);

// =====================
// Door (motor + limit + infrared sensor)
// =====================
Door door(gearmotor, limitDoor, limitDoorClose, doorSensor);

// =====================
// OLED
// =====================
Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);

// =====================
// ButtonUI
// =====================
ButtonUI actionButton(interfaceI2C3, SERVICE_BUTTON_PIN, true);

// =====================
// Interface UI (oled + actionButton)
// =====================
InterfaceUI interfaceUI(display, actionButton);

// =====================
// Managers
// =====================
MotorManager motorManager;
SensorManager sensorManager;
FillLevelManager fillManager;
ContainerManager containerManager;
// =====================
// Protocols
// =====================
MotionProtocol motionP(motorManager, sysController);
StatusProtocol statusP(sysController);
SensorProtocol sensorP(sensorManager);
CalibrationProtocol calibrationP(sensorHX711);
ContainerProtocol containerP(containerManager);
DoorProtocol doorP(door);
// =====================
// Router
// =====================
CommandRouter router(motionP, statusP, sensorP, calibrationP, containerP, doorP);

// =====================
// System Manager
// =====================
SystemManager systemManager(
	motorManager,
	router,
	sysController,
	interfaceUI,
	camera,
	fillManager,
	wsService,
	qrService,
	sensorManager,
	sensorHX711,
	containerManager,
	pirSensor,
	door,
	dumpServo);

// WebSocket Client with Server
void webSocketEvent(WStype_t type, uint8_t *payload, size_t length)
{
	switch (type)
	{

	case WStype_DISCONNECTED:
		Logger::error("[WSS] Disconnected!");
		break;
	case WStype_CONNECTED:
		Logger::info("[WSS] Connected to backend!");
		// Enviar registro inicial
		{
			JsonDocument doc;
			doc["type"] = "REGISTER";
			doc["id"] = id;
			String output;
			serializeJson(doc, output);
			webSocketSrvr.sendTXT(output);
		}
		break;

	case WStype_TEXT:
		String mesg = (char *)payload;
		Logger::info("[WSS] Message received:");
		Logger::info(mesg.c_str());

		if (mesg.equals("QR_SUCCESS"))
		{
			// Lógica para abrir puerta, encender led verde, etc.
			Logger::info("¡Acceso concedido!");
			wsService.sendText("QR_SUCCESS");
		}
		else if (mesg.equals("QR_FAILURE"))
		{
			// Lógica de error
			Logger::error("Acceso denegado.");
		}
		else if (mesg.startsWith("COL:") && mesg.length() == 8)
		{
			// Notifica pantalla
			wsService.sendText(mesg);
			// Verificamos si el mensaje empieza con "COL:" y tiene el tamaño correcto 8 caracteres
			// COL: toma de 0 a 3, los caracteres de los materiales están en los índices 4, 5, 6 y 7
			// msg[0] = 'C', msg[1] = 'O', msg[2] = 'L', msg[3] = ':'
			bool collectMetal = (mesg[4] == '1');
			bool collectPlastic = (mesg[5] == '1');
			bool collectCardboard = (mesg[6] == '1');
			bool collectGlass = (mesg[7] == '1');

			// Ejecutar las acciones (abrir compuertas, activar motores, etc.)
			if (collectMetal)
			{
				Logger::info("-> Activando recolección de METAL");
				containerManager.unlock('1');
			}
			if (collectPlastic)
			{
				Logger::info("-> Activando recolección de PLÁSTICO");
				containerManager.unlock('2');
			}
			if (collectCardboard)
			{
				Logger::info("-> Activando recolección de CARTÓN");
				containerManager.unlock('3');
			}
			if (collectGlass)
			{
				Logger::info("-> Activando recolección de VIDRIO");
				containerManager.unlock('4');
			}
		}
		break;
	}
}

// Get current timestamp to gen QR
time_t getTime()
{
	time_t now;
	time(&now);

	if (now > 1000000)
	{
		String timeStr = "Current Unix Timestamp: " + String(now);
		Logger::info(timeStr.c_str());
	}
	else
	{
		Logger::info("Sincronizando hora...");
		vTaskDelay(100 / portTICK_PERIOD_MS);
	}
	return now;
}

void setup()
{
	Serial.begin(SERIAL_BAUD_RATE);
	Logger::info("Serial Started");
	// Configue NTP(0, 0 to obtain UTC without gap)
	configTime(0, 0, ntpServer);
	// Connection with Backend Node.js
	webSocketSrvr.beginSSL("diakron-backend.onrender.com", 443, "/");
	webSocketSrvr.onEvent(webSocketEvent);
	webSocketSrvr.setReconnectInterval(5000);

	// Turn on INBOARD LED
	pinMode(GPIO_NORMAL_LED, OUTPUT);
	digitalWrite(GPIO_NORMAL_LED, 1);
	// Initi I2C with custom pins
	Wire.begin(GPIO_I2C_SDA, GPIO_I2C_SCL);
	// 400 KHz Max stable I2C velocity
	Wire.setClock(400000);

	// Print message if psram
	if (psramFound)
		Logger::info("psramFound");

	// Initialize with default address 0x20 on the custom wire
	mcp1_ok = mcp.begin_I2C(0x20, &Wire);

	if (!mcp1_ok)
	{
		Logger::error("Could not initialize MCP23017 at address 0x20!");
	}
	else
	{
		Logger::info("MCP23017 initialized at address 0x20");
	}
	// Initialize with address 0x21 on the custom wire
	mcp2_ok = mcp2.begin_I2C(0x21, &Wire);

	if (!mcp2_ok)
	{
		Logger::error("Could not initialize MCP23017 at address 0x21!");
	}
	else
	{
		Logger::info("MCP23017 initialized at address 0x21");
	}

	mcp3_ok = mcp3.begin_I2C(0x22, &Wire);

	if (!mcp3_ok)
	{
		Logger::error("Could not initialize MCP23017 at address 0x22!");
	}
	else
	{
		Logger::info("MCP23017 initialized at address 0x22");
	}
	// Start Wifi
	interfaceUI.begin();
	wifiService.init(server, interfaceUI);

	// Start websocket and set callback for messages from HMI
	wsService.init();
	segregatorWeb.init();
	wsService.onMessage([&](const String &msg)
						{ systemManager.handleExternalCommand(msg); });

	Logger::setWebSocketService(&wsService);
	Logger::info("Sistema inicializado y vinculado a la terminal remota");

	// Start server
	server.begin();

	delay(1000);
	// Camera init
	camera.attachWebSocket(&wsService);
	camera.init();
	// QR Service begin
	qrService.begin();

	// Servo init
	dumpServo.attach(SERVO_DUMP_PIN);
	dumpServo.write(0);

	// Initialize sensors
	sensorHX711.begin();
	binMetal.begin();
	binPlastic.begin();
	binPaper.begin();
	binGlass.begin();
	sensorCAPC.begin();
	sensorINDU.begin();
	pirSensor.begin();
	sensorManager.addSensor('C', &sensorCAPC);
	sensorManager.addSensor('I', &sensorINDU);

	motorHead.begin();
	motorHead.enable(false);

	motorSensorINDU.begin();

	motorSensorCAPC.begin();
	// Initialize home switch axis
	limitHead.begin();
	limitINDU.begin();
	// Add axis to manager
	motorManager.addAxis('H', &axisHead);
	// motorManager.addAxis('I', &axisINDU);
	// motorManager.addAxis('C', &axisCAPC);
	//  Add fill level sensors to manager
	fillManager.addSensor(&binMetal);
	fillManager.addSensor(&binPlastic);
	fillManager.addSensor(&binPaper);
	fillManager.addSensor(&binGlass);

	// Containers
	containerMetal.begin();
	containerPlastic.begin();
	containerPaper.begin();
	containerGlass.begin();
	// Manager
	containerManager.addContainer('1', &containerMetal);
	containerManager.addContainer('2', &containerPlastic);
	containerManager.addContainer('3', &containerPaper);
	containerManager.addContainer('4', &containerGlass);
	// Door
	door.begin();

	systemManager.init();

	axisHead.startHoming();
}

void loop()
{

	wsService.update();
	systemManager.update();
	webSocketSrvr.loop();
	if (Serial.available())
	{
		static char buffer[64];
		size_t len = Serial.readBytesUntil('\n', buffer, sizeof(buffer) - 1);
		buffer[len] = '\0';

		systemManager.processCommand(buffer);
	}

	/*
	IMPORTANT
	This is not an ordinary delay while is critical for
	Wifi, Http, and websockets to have this time to 'work'
	IF this time is not given, the WDT will potentially reset the esp32
	during network processes
	*/
	if (sysController.getState() != SystemState::HOMING &&
		sysController.getState() != SystemState::RUNNING)
	{
		vTaskDelay(20 / portTICK_PERIOD_MS);
	}
}