#include <Wire.h>
#include <Servo.h>

#define servoPin1 9
#define servoPin2 10
Servo servo1;
Servo servo2;

int angle=0;
String come[2];

int dis_new = 0;

int sunseo = 0;
int act = 0;

int count = 0;

bool scanning = 0;


//TOF10120 모듈의 I2C 주소
#define TOF10120 0x52 //0xA4 > 0x52(7Bit)  

void SensorRead(unsigned char addr,unsigned char* datbuf,unsigned char cnt) 
{
  unsigned short result=0; 
  Wire.beginTransmission(TOF10120);
  Wire.write(byte(addr));  
  Wire.endTransmission();
  Wire.requestFrom(TOF10120, (int)cnt);
  if (cnt <= Wire.available()) {
    *datbuf++ = Wire.read();
    *datbuf++ = Wire.read();
  }
}

int ReadDistance()
{      
    unsigned short distance;
    unsigned char i2c_rx_buf[2];

    SensorRead(0x00,i2c_rx_buf,2);
    
    distance=i2c_rx_buf[0];
    distance=distance<<8;
    distance =i2c_rx_buf[1];
 
    delay(100); 
    return distance;
}


void setup() {

  Wire.begin();

  Serial.begin(9600);

  servo1.attach(servoPin1);
  servo2.attach(servoPin2);

  servo1.write(90);
  servo2.write(90);

  pinMode(13, OUTPUT);
}

void loop() {

  int x=ReadDistance();
  dis_new = x;

  while(Serial.available()){
    come[sunseo] = Serial.readStringUntil('/');
    sunseo++;
    if(sunseo == 2){
      sunseo = 0;
    }

    tone(13, 440, 250);
    delay(100);
  }

  

  if(come[act] == "1" && dis_new <= 50){
      servo1.write(120);
      servo2.write(115);

      come[act] = "X";
      
      act++;
      if(act == 2){
        act = 0;
      }
      tone(13, 262, 250);
      delay(100);

    }
    
    else if(come[act] == "0" && dis_new <= 50){
      servo1.write(75);
      servo2.write(75);

      come[act] = "X";
      act++;
      if(act == 2){
        act = 0;
      }      

      tone(13, 500, 250);
      delay(100);
    }


}