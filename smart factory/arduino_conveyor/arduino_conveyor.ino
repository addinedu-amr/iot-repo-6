#include <LiquidCrystal_I2C.h>
LiquidCrystal_I2C lcd(0x3f, 16, 2);
#define TRIG 9
#define ECHO 8
#include <SoftwareSerial.h>
SoftwareSerial mySerial(12,13);
bool is_start = 0;
bool dont_move = 0;
bool app_control = 0;
bool serial_come = 0;
bool serial_move = 0;
bool serial_choum = 0;
int count = 0;
int warning = 0;
int speed = 255/7;
long distance;
char c;
String LCD_print;
void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  mySerial.begin(9600);
  pinMode(4, 1);
  pinMode(5, 1);
  pinMode(TRIG, OUTPUT);
  pinMode(ECHO, INPUT);
  pinMode(7, OUTPUT);
  pinMode(6, OUTPUT);
  lcd.begin();
  lcd.backlight();

}
void loop() {
  if(speed == 255/7){
    digitalWrite(7, LOW);
    digitalWrite(6, HIGH);
  }
  else{
    digitalWrite(6, LOW);
    digitalWrite(7, HIGH);
  }
  if(mySerial.available()){
    c = mySerial.read();
    if(c =='1')
      app_control = 1;
    else if(c =='0')
      app_control = 0;
      Serial.println(app_control);
  }
  if(dont_move == 0  && app_control == 1){
    speed = 255/7;
    serial_come = 0;
  }
  if(app_control == 1){
    if(serial_move == 0){
      mySerial.write("move\r\n");
      LCD_print = "I'm move";
      lcd.begin();
      lcd.setCursor(0, 0);
      lcd.print(LCD_print);
    }
    serial_move = 1;
    if(count < 10000){
      long duration;
      digitalWrite(TRIG, LOW);
      delayMicroseconds(2);
      digitalWrite(TRIG, HIGH);
      delayMicroseconds(10);
      digitalWrite(TRIG, LOW);
      duration = pulseIn(ECHO, HIGH); // 초음파를 받은 시간 (LOW 에서 HIGH 로 )
      distance = duration * 17 / 1000; // cm 로 환산 (34000 / 10000000 /2 를 간단하게)
    if(distance < 5)
      warning++;
    else
      warning = 0;
    count = 0;
    }
    count++;
    if(warning < 3 && dont_move == 0){
      if (is_start == 0) {
        digitalWrite(4, 1); // 5V :app +
        digitalWrite(5, 0); // GND (0V) :-
        analogWrite(3, 255);
        delay(100);
        is_start = 1;
      }
:
      digitalWrite(4, 1); // 5V : +
      digitalWrite(5, 0); // GND (0V) :-
      analogWrite(3, speed);

    }
    else{
      dont_move = 1;
      if(speed > 5){
        speed = speed - 5;
      }
      else{
        if(serial_choum == 0){
          mySerial.write("choumpa_stop\r\n");
          LCD_print = "choumpa active I'm stop!";
          lcd.begin();
          lcd.setCursor(0, 0);
          lcd.print(LCD_print);
          serial_choum = 1;
        }
        speed = 0;
        delay(1000);
        if(distance >= 5){
          mySerial.write("move\r\n");
          LCD_print = "I'm move!";
          lcd.begin();
          lcd.setCursor(0, 0);
          lcd.print(LCD_print);
          serial_choum = 0;
          dont_move = 0;
          warning = 0;
          is_start = 0;
          speed = 255/7;
        }
      }
    analogWrite(3, speed);
    }
  }
  else{
      if(speed <= 15){
        speed = 0;
        if (serial_come == 0){
          mySerial.write("stop\r\n");
          LCD_print = "I'm stop!";
          lcd.begin();
          lcd.setCursor(0, 0);
          lcd.print(LCD_print);
          serial_come = 1;
        }
        is_start = 0;
      }
      else{
        speed -= 15;
        delay(100);
        analogWrite(3, speed);
      }
    serial_move = 0;
    analogWrite(3, speed);
    delay(100);
  }

}
