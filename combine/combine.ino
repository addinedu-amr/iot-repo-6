/*
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
    Serial.println(come);
    lcd.begin();
    lcd.setCursor(0, 0);
    lcd.print(come);
    delay(500);
  }
}
*/

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
    //모듈의 0x00번지부터 2바이트 읽어오기
    SensorRead(0x00,i2c_rx_buf,2);
    
    //읽어온 두 바이트를 변수 하나로 합침
    // i2c_rx_buf[0] : 상위 바이트
    // i2c_rx_buf[1] : 하위 바이트
    distance=i2c_rx_buf[0];
    distance=distance<<8;
    distance|=i2c_rx_buf[1];
 
    //300ms 대기
    delay(100); 
    return distance;
}


void setup() {
  //I2C 라이브러리 시작
  Wire.begin();


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
  int x=ReadDistance();
    //시리얼 모니터에 출력
  dis_new = x;


  while(Serial.available()){
    //모듈에서 거리 데이터 읽어보기
    come[sunseo] = Serial.readStringUntil('/');
    sunseo++;
    if(sunseo == 2){
      sunseo = 0;
    }
  }

  

  if(come[act] == "1" && dis_new <= 50){
      servo1.write(120);
      servo2.write(115);

      come[act] = "X";
      
      act++;
      if(act == 2){
        act = 0;
      }
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
      delay(100);
    }


}