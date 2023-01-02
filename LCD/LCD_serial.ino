String come;

#include <LiquidCrystal_I2C.h>
LiquidCrystal_I2C lcd(0x3f, 16, 2);


void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  lcd.begin();
  lcd.backlight();
}

void loop() {

  while(Serial.available()){
    String come = Serial.readStringUntil('/');
    lcd.begin();
    lcd.setCursor(0, 0);
    lcd.print(come);
    delay(250);
  }
}