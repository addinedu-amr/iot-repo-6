//#include <Wire.h>
#include <LiquidCrystal_I2C.h>

LiquidCrystal_I2C lcd(0x3f, 16, 2);

void setup() {
  // put your setup code here, to run once:
  lcd.begin();
  lcd.backlight();
  
}

void loop() {
  // put your main code here, to run repeatedly:
  lcd.setCursor(0, 0);
  lcd.print("Hello world!  ");
  lcd.setCursor(0, 1);
  lcd.print("Hi im name  ");
  delay(5000);

  lcd.setCursor(0, 0);
  lcd.print("bye world   ");
  lcd.setCursor(0, 1);
  lcd.print("Hi your name");
  delay(5000);

}