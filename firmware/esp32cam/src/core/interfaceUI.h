#pragma once

#include "../drivers/buttonUI.h"

#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>

#include "../config/icon.h"
#include "../config/defaults.h"

#include "../communication/logger.h"

/*
=====================================================
                    UI STATES
=====================================================
*/

enum UIState
{
    UI_BOOT,

    UI_CONNECTING_WIFI,
    UI_AP_MODE,
    UI_WIFI_STATUS,

    UI_MESSAGE,

    /*
        DASHBOARD
    */
    UI_MENU,

    /*
        SERVICE MENU
    */
    UI_HOME_MOTORS,
    UI_SENSOR_STATUS,
    UI_DOOR_MENU,
    UI_WEIGHT_MENU,
    UI_MANUAL_START
};

class InterfaceUI
{
private:

    /*
    =====================================================
                        DEVICES
    =====================================================
    */

    ButtonUI& button;

    Adafruit_SSD1306& display;

    /*
    =====================================================
                        UI STATE
    =====================================================
    */

    UIState currentState;

    uint8_t selectedIndex;

    uint8_t menuLength;

    bool needsRedraw;

    unsigned long lastRender = 0;

    /*
    =====================================================
                        MENU ITEMS
    =====================================================
    */

    struct MenuItem
    {
        const char* label;

        UIState targetState;
    };

    static const MenuItem menuItems[];

    /*
    =====================================================
                        WIFI INFO
    =====================================================
    */

    String wifiSSID;

    String wifiPassword;

    String wifiIP;

    bool apMode = false;

    /*
    =====================================================
                        MESSAGE
    =====================================================
    */

    String messageText;

    /*
    =====================================================
                    INTERNAL METHODS
    =====================================================
    */

    void drawCurrentScreen();

public:

    /*
    =====================================================
                        CONSTRUCTOR
    =====================================================
    */

    InterfaceUI(
        Adafruit_SSD1306& oled,
        ButtonUI& btn);

    /*
    =====================================================
                        MAIN
    =====================================================
    */

    void begin();

    void update();

    /*
    =====================================================
                    MENU CONTROL
    =====================================================
    */

    void ui_nextItem();

    void ui_select();

    UIState ui_getState();

    /*
    =====================================================
                    WIFI STATUS
    =====================================================
    */

    void setWifiInfo(
        const String& ssid,
        const String& pass,
        const String& ip,
        bool ap);

    /*
    =====================================================
                        MESSAGE
    =====================================================
    */

    void showMessage(
        const String& msg);

    /*
    =====================================================
                    EXTERNAL STATE
    =====================================================
    */

    void setState(
        UIState state);
};