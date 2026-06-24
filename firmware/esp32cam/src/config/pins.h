#define GPIO_CAPC 7
#define GPIO_INDU 6
#define GPIO_I2C_SDA 14
#define GPIO_I2C_SCL 15
#define GPIO_NORMAL_LED 33

// These pins are assigned in such a way as to work with 
// version 1.1 of the specialized electronic board of the 
// Diakron segregator head

// MOTOR PINS (INTERFACE I2C) 
#define HEAD_STEP_PIN 1 // I2C 0x20
#define HEAD_DIR_PIN 2 // I2C 0x20
#define HEAD_ENABLE_PIN 0 // I2C 0x20

#define INDU_STEP_PIN_1 8 // I2C 0x20
#define INDU_STEP_PIN_2 9 // I2C 0x20
#define INDU_STEP_PIN_3 10 // I2C 0x20
#define INDU_STEP_PIN_4 11 // I2C 0x20

#define CAPC_STEP_PIN_1 12 // I2C 0x20 
#define CAPC_STEP_PIN_2 13 // I2C 0x20 
#define CAPC_STEP_PIN_3 14 // I2C 0x20
#define CAPC_STEP_PIN_4 15 // I2C 0x20

// LIMIT SWITCHES PINS
#define LIMIT_HEAD_PIN 3 // I2C 0x20
#define LIMIT_INDU_PIN 4 // I2C 0x20
#define LIMIT_CAPC_PIN 5 // I2C 0x20

// OLED SCREEN
#define SERVICE_BUTTON_PIN 5 // I2C 0x22

// PIR SENSOR
#define PIR_SENSOR_PIN 6 // I2C 0x22

// HX711 Sensor 
#define HX711_DOUT_PIN 2 // GPIO
#define HX711_SCK_PIN 4 // GPIO

// HC-SR04 Ultrasonic Sensor
#define PCF_TRIG 4 // I2C 0x22 // Four HC-SR04 ultrasonic sensors, using same trigger pin, different echo 
#define binMetalEchoPin 0 // I2C 0x22
#define binPlasticEchoPin 1 // I2C 0x22
#define binPaperEchoPin 2 // I2C 0x22
#define binGlassEchoPin 3 // I2C 0x22

// Segurity door
#define DOOR_SENSOR_IR 10 // I2C 0x21
#define LIMIT_OPEN_DOOR 9 // I2C 0x21
#define LIMIT_CLOSE_DOOR 8 // I2C 0x21
#define MOTOR_DOOR_PIN_IZQ 11 // I2C 0x21
#define MOTOR_DOOR_PIN_DER 12 // I2C 0x21

// Solenoid Locks
#define SOLENOID_LOCK_1 0 // I2C 0x21
#define SOLENOID_LOCK_2 1 // I2C 0x21
#define SOLENOID_LOCK_3 2 // I2C 0x21
#define SOLENOID_LOCK_4 3 // I2C 0x21
#define LIMIT_SOLENOID_1 4 // I2C 0x21
#define LIMIT_SOLENOID_2 5 // I2C 0x21
#define LIMIT_SOLENOID_3 6 // I2C 0x21
#define LIMIT_SOLENOID_4 7 // I2C 0x21

// Servo Dump
#define SERVO_DUMP_PIN 13 // GPIO