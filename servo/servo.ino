#include <Servo.h>

#define servoPin1 9
#define servoPin2 10
#define TRIG 8 //TRIG 핀 설정 (초음파 보내는 핀)
#define ECHO 7 //ECHO 핀 설정 (초음파 받는 핀)
#define BTN 2 // 비상정지 버튼

Servo servo1;
Servo servo2;

int angle=0;
bool flag = 0;
bool flag_emergency = 0;

void setup() {
  // put your setup code here, to run once:
  servo1.attach(servoPin1);
  servo2.attach(servoPin2);
	Serial.begin(9600);
	pinMode(TRIG, OUTPUT);
	pinMode(ECHO, INPUT);
	pinMode(BTN, INPUT);
}

void loop() {
  while (1){

    long duration, distance;
    digitalWrite(TRIG, LOW);
    delayMicroseconds(2);
    digitalWrite(TRIG, HIGH);
    delayMicroseconds(10);
    digitalWrite(TRIG, LOW);
    duration = pulseIn(ECHO, HIGH); // 초음파를 받은 시간 (LOW 에서 HIGH 로 )
    distance = duration * 17 / 1000; // cm 로 환산 (34000 / 10000000 /2 를 간단하게)
    Serial.print("\nDIstance : ");
    Serial.print(distance);
    Serial.println(" cm");

    bool incomming_data = digitalRead(BTN);
    if (incomming_data==HIGH) {
      if (flag==0) {
        Serial.println("Button is pressed.");
        flag = 1;
        flag_emergency = !(flag_emergency);
      }
    }

    if (incomming_data==LOW) {
      if (flag==1) {
        Serial.println("---");
        flag = 0;
      }
    }

    if ((distance <= 5) || (flag_emergency == 1)) {
      // put your main code here, to run repeatedly:
      // To the Left, classification
      continue;
    }
    servo1.write(180);
    servo2.write(45);
    
    delay(200);

      // To the Right, classification
    servo1.write(135);
    servo2.write(0);
    
    delay(200);

  }
}
