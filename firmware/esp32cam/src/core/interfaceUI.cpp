#include "interfaceUI.h"

const InterfaceUI::MenuItem InterfaceUI::menuItems[] =
{
    {"Homing", UI_HOME_MOTORS},
    {"Sensor Status", UI_SENSOR_STATUS},
    {"Door", UI_DOOR_MENU},
    {"Weight", UI_WEIGHT_MENU},
    {"Manual Start", UI_MANUAL_START}
};

InterfaceUI::InterfaceUI(
    Adafruit_SSD1306& oled,
    ButtonUI& btn)
    : button(btn),
      display(oled)
{
    menuLength =
        sizeof(menuItems) /
        sizeof(menuItems[0]);

    currentState = UI_BOOT;

    selectedIndex = 0;

    needsRedraw = true;

    wifiSSID = "";
    wifiPassword = "";
    wifiIP = "";

    apMode = false;

    messageText = "";
}

void InterfaceUI::begin()
{
    if (!display.begin(
        SSD1306_SWITCHCAPVCC,
        OLED_ADDR))
    {
        Logger::error("OLED INIT FAILED");
        return;
    }

    display.clearDisplay();

    display.setTextColor(SSD1306_WHITE);

    display.setTextSize(1);

    display.drawBitmap(
        (display.width() - LOGO_WIDTH) / 2,
        0,
        diakronIc,
        LOGO_WIDTH,
        LOGO_HEIGHT,
        WHITE);

    display.display();

    delay(1200);

    currentState = UI_MENU;

    needsRedraw = true;
}

void InterfaceUI::update()
{
    if (millis() - lastRender < 120)
        return;

    lastRender = millis();

    ButtonEvent evt =
        button.handleButton();

    /*
    =========================================
            DASHBOARD / MENU ACCESS
    =========================================
    */

    if (currentState == UI_MENU)
    {
        if (evt == ButtonEvent::LONG_PRESS)
        {
            selectedIndex = 0;

            currentState = UI_HOME_MOTORS;

            needsRedraw = true;
        }
    }
    else
    {
        /*
            SHORT PRESS:
            NEXT ITEM
        */

        if (evt == ButtonEvent::SHORT_PRESS)
        {
            ui_nextItem();

            needsRedraw = true;
        }

        /*
            LONG PRESS:
            SELECT / RETURN
        */

        else if (evt == ButtonEvent::LONG_PRESS)
        {
            ui_select();

            needsRedraw = true;
        }
    }

    if (needsRedraw)
    {
        drawCurrentScreen();

        needsRedraw = false;
    }
}

void InterfaceUI::drawCurrentScreen()
{
    display.clearDisplay();

    display.setTextSize(1);

    display.setTextColor(SSD1306_WHITE);

    switch (currentState)
    {

    /*
    =====================================================
                        BOOT
    =====================================================
    */

    case UI_BOOT:
    {
        display.drawBitmap(
            (display.width() - LOGO_WIDTH) / 2,
            0,
            diakronIc,
            LOGO_WIDTH,
            LOGO_HEIGHT,
            WHITE);

        display.setCursor(25, 50);

        display.println("BOOTING...");
    }
    break;

    /*
    =====================================================
                    CONNECTING WIFI
    =====================================================
    */

    case UI_CONNECTING_WIFI:
    {
        display.setCursor(0, 0);
        display.println("WIFI CONNECTING");

        display.drawLine(0, 10, 128, 10, WHITE);

        display.setCursor(0, 20);
        display.print("SSID:");

        display.setCursor(0, 32);

        if (wifiSSID.length() > 18)
            display.println(wifiSSID.substring(0, 18));
        else
            display.println(wifiSSID);

        display.setCursor(0, 54);
        display.println("Please wait...");
    }
    break;

    /*
    =====================================================
                        AP MODE
    =====================================================
    */

    case UI_AP_MODE:
    {
        display.setCursor(0, 0);
        display.println("SETUP MODE");

        display.drawLine(0, 10, 128, 10, WHITE);

        display.setCursor(0, 20);
        display.println("SSID:");

        display.setCursor(0, 30);
        display.println("Diakron-Setup");

        display.setCursor(0, 44);
        display.println("PASS: 12345678");
    }
    break;

    /*
    =====================================================
                    WIFI STATUS
    =====================================================
    */

    case UI_WIFI_STATUS:
    {
        display.setCursor(0, 0);
        display.println("WIFI CONNECTED");

        display.drawLine(0, 10, 128, 10, WHITE);

        display.setCursor(0, 20);
        display.print("SSID:");

        display.setCursor(0, 30);

        if (wifiSSID.length() > 18)
            display.println(wifiSSID.substring(0, 18));
        else
            display.println(wifiSSID);

        display.setCursor(0, 46);
        display.print("IP:");

        display.setCursor(0, 56);
        display.println(wifiIP);
    }
    break;

    /*
    =====================================================
                    DASHBOARD
    =====================================================
    */

    case UI_MENU:
    {
        /*
            HEADER
        */

        display.fillRect(0, 0, 128, 12, WHITE);

        display.setTextColor(BLACK);

        display.setCursor(4, 2);

        display.print("DIAKRON");

        display.setCursor(88, 2);

        if (wifiIP != "")
            display.print("WiFi");
        else
            display.print("X");

        /*
            BODY
        */

        display.setTextColor(WHITE);

        display.setCursor(0, 18);
        display.println("SYSTEM READY");

        display.setCursor(0, 30);
        display.print("SSID:");

        if (wifiSSID.length() > 10)
            display.println(wifiSSID.substring(0, 10));
        else
            display.println(wifiSSID);

        display.setCursor(0, 42);
        display.println("Sensors: OK");

        display.setCursor(0, 54);
        display.println("Hold Btn -> Menu");
    }
    break;

    /*
    =====================================================
                    MENU ITEMS
    =====================================================
    */

    case UI_HOME_MOTORS:
    case UI_SENSOR_STATUS:
    case UI_DOOR_MENU:
    case UI_WEIGHT_MENU:
    case UI_MANUAL_START:
    {
        display.setCursor(0, 0);
        display.println("SERVICE MENU");

        display.drawLine(0, 10, 128, 10, WHITE);

        for (uint8_t i = 0; i < menuLength; i++)
        {
            int y = 16 + (i * 10);

            if (i == selectedIndex)
            {
                display.fillRect(
                    0,
                    y - 1,
                    128,
                    10,
                    WHITE);

                display.setTextColor(BLACK);
            }
            else
            {
                display.setTextColor(WHITE);
            }

            display.setCursor(4, y);

            display.println(menuItems[i].label);
        }
    }
    break;

    /*
    =====================================================
                        MESSAGE
    =====================================================
    */

    case UI_MESSAGE:
    {
        display.setCursor(0, 20);

        display.println(messageText);
    }
    break;

    default:
        break;
    }

    display.display();
}

void InterfaceUI::ui_nextItem()
{
    selectedIndex++;

    if (selectedIndex >= menuLength)
    {
        selectedIndex = 0;
    }

    currentState =
        menuItems[selectedIndex]
            .targetState;
}

void InterfaceUI::ui_select()
{
    switch (currentState)
    {

    case UI_HOME_MOTORS:
        Logger::info("HOMING REQUEST");
        break;

    case UI_SENSOR_STATUS:
        Logger::info("SENSOR STATUS");
        break;

    case UI_DOOR_MENU:
        Logger::info("DOOR MENU");
        break;

    case UI_WEIGHT_MENU:
        Logger::info("WEIGHT MENU");
        break;

    case UI_MANUAL_START:
        Logger::info("MANUAL START");
        break;

    default:
        currentState = UI_MENU;
        break;
    }
}

UIState InterfaceUI::ui_getState()
{
    return currentState;
}

void InterfaceUI::setWifiInfo(
    const String& ssid,
    const String& pass,
    const String& ip,
    bool ap)
{
    wifiSSID = ssid;

    wifiPassword = pass;

    wifiIP = ip;

    apMode = ap;

    needsRedraw = true;
}

void InterfaceUI::showMessage(
    const String& msg)
{
    messageText = msg;

    currentState = UI_MESSAGE;

    needsRedraw = true;
}

void InterfaceUI::setState(
    UIState state)
{
    currentState = state;

    needsRedraw = true;
}