+++
title = "Use OLED Display of ESP8266 NodeMCU with U8g2 library"
date = "2023-12-17"
tags = [
    "embedded",
    "esp8266",
    "oled",
    "u8g2",
]
+++

The ESP8266 board with an attached 0.96 inch OLED display is a great deal.
I bought is for about 6 Euros. The full title of my offering was
"NodeMCU ESP8266 Development Board w/0.96" OLED Display CH340 Driver Module USB-C".

Unfortunately. the description in the offering is incorrect and the OLED display does
not work as expected when using the code/values given in the description.
<!--more-->

In the description, the SCA and SCL port numbers are interchanged.
Here is a short working example with the correct values:
```
#include <Arduino.h>
#include <SPI.h>
#include <Wire.h>
#include <U8g2lib.h>

U8G2_SSD1306_128X64_NONAME_F_SW_I2C u8g2(U8G2_R0, /* clock= */ 12, /* data= */ 14, /* reset= */ U8X8_PIN_NONE);

void setup(void)
{
    u8g2.begin();
}

void loop(void)
{
    u8g2.clearBuffer();
    u8g2.setFont(u8g2_font_7x14B_tr);
    u8g2.drawStr(0, 15, "Hello World!");
    u8g2.sendBuffer();
}
``` 

The relevant part is in the constructor of the `u8g2` instance. Make sure to use the
correct values for SCA and SCL.
