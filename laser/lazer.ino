#include <Wire.h> //i2c 라이브러리

//TOF10120 모듈의 I2C 주소
#define TOF10120 0x52 //0xA4 > 0x52(7Bit)  

int dis_new = 0;
int count = 0;

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

// TOF10120모듈에 거리 데이터 읽는 함수
// 리턴값 : 거리데이터 미리미터(mm)
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

void setup() 
{
  //I2C 라이브러리 시작
  Wire.begin();
  //디버그 시리얼 모니터 시작 
  Serial.begin(9600);
}

void loop() 
{
  //모듈에서 거리 데이터 읽어보기
  int x=ReadDistance();
  //시리얼 모니터에 출력
  Serial.print(x);
  Serial.println(" mm");
  dis_new = x;
  int diff_dis = dis_new - dis_old;

  if (dis_new <= 50) {
    count += 1;
  }

  Serial.print("Count Object : ");
  Serial.println(count);
}