#include <Servo.h>

#define servoPin1 9
#define servoPin2 10
Servo servo1;
Servo servo2;

int angle=0;
String come;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);

  servo1.attach(servoPin1);
  servo2.attach(servoPin2);

  servo1.write(90);
  servo2.write(90);
}

void loop() {
  //put your main code here, to run repeatedly:
  // To the Left, classification
  while(Serial.available()){
    String come = Serial.readStringUntil('/');
    if(come == "1"){
      servo1.write(120);
      servo2.write(115);
      delay(100);
    }
    else if(come == "0"){
// To the Right, classification
    servo1.write(75);
    servo2.write(75);

    delay(100);
    }
  }
}