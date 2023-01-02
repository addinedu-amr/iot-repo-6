# 스마트 팩토리 ( smart factory )
![smartfactory](https://user-images.githubusercontent.com/110883172/210024375-fc7a94e9-afea-4a4e-bf34-c167016dacc8.png)

</br>
</br>

## 개요
### 문제인식
- 자동화된 생산라인에서 어떻게 하면 수율을 올릴 수 있을까?
- 자동화된 생산라인에서 어떻게 하면 안정성을 높일 수 있을까?
- 자동화된 생산라인과 IOT는 어떻게 접목될 수 있을까?


</br>


### 전략
- 수율을 올리기 위해서는 정확한 불량여부 판단이 필요할 것이다.
- 안정성을 높이기 위해서는 자동화된 생산라인에 작업자의 접근을 차단해야한다.
- 작업자가 외부에서 스마트 기기를 이용해 공장 내부의 상황을 실시간으로 모니터링 할 수 있게 하자.


</br>
</br>


## 프로젝트 설계도 및 배치
![블록선도 drawio](https://user-images.githubusercontent.com/110883172/210239215-edd5acf7-f9e5-409b-80ea-1aa23dc0c62a.png)


</br>
</br>


## 역할 분담
#### 정재욱 
###### 담당
- 프로젝트 기획 및 물품구매
- 각 센서들의 동작을 구현
- 노션관리

#### 조이삭
###### 담당
- 플루터를 이용한 앱 제작
- 아두이노와 앱 간의 데이터 통신 정의 및 구현
- 앱의 디자인 설계
 
#### 이미영
###### 담당
- 프로젝트의 데이터 흐름 정리
- AWS상으로 데이터를 전송하고, 이를 언리얼엔진, 앱등으로 전송하는 역할
- 앱 제작

#### 김두엽
###### 담당
- 프로젝트 설계
- 아두이노의 동작 구현
- 깃헙 관리

#### 류도현
###### 담당
- 언리얼 엔진을 통한 3D 공장 구현
- 언리얼 엔진을 통한 디지털 트윈 구현
- 각 센서들의 동작을 구현


</br>
</br>


-------

## PART 1. 물품구매와 각 센서들의 동작 구현
### __ㅇ 컨베이어 벨트__
#### __>> 컨베이어 벨트 구매 및 제작__
  <center><img src="https://user-images.githubusercontent.com/110883172/210024853-8f2cd202-db46-435d-8ff9-c8b6071170ff.png" width="400" height="400"/></center>

#### __>> 아두이노를 통한 구현 과정__
<center><img src="https://user-images.githubusercontent.com/110883172/210024957-d39deb3f-3cae-439f-afb8-d2194a50f105.png" width="400" height="400"/></center>

아두이노와 모터드라이브를 통해 컨베이어벨트의 속도 조절

초음파센서를 이용하여 작업자가 접근하는 경우 컨베이어벨트 비상 정지

비상정지 버튼을 누르는 경우 컨베이어벨트 비상정지

</br>
</br>


### __LCD 구현__
<center><img src="https://user-images.githubusercontent.com/110883172/210240605-6bf25a0b-aa0e-4efd-815f-6ded8de6522e.png" width="800" height="200"/></center>

LCD를 화면에 띄우는 것과 시리얼 통신으로 입력받은 데이터를 LCD에 띄우는 것을 구현함.

</br>
</br>


### __서보모터__
<center><img src="https://user-images.githubusercontent.com/110883172/210241633-1174424b-e527-46ec-9772-caf32a1123c9.png" width="400" height="200"/></center>

서보모터를 통해 불량품과 양품을 구별함.

</br>
</br>


### __레이저 센서__
<center><img src="https://user-images.githubusercontent.com/110883172/210241986-66503b9e-2186-4fec-877a-adf6067078c4.png" width="400" height="200"/></center>

레이저 센서를 통해 물품을 인식하고, 개수를 카운트하도록 구현함.

</br>
</br>


------

## PART 2. 생산품의 불량여부 판단
### OpenCV 허프변환을 통한 원검출
#### 동전을 검출해보기
<center><img src="https://user-images.githubusercontent.com/110883172/210025302-9d2c4a95-28b3-4ba2-8281-3070f7a806d5.png" width="600" height="600"/></center>

</br>
</br>

#### 컨베이어 벨트에서의 circle detection 실험
![KakaoTalk_20230102_231822804_AdobeExpress](https://user-images.githubusercontent.com/110883172/210243614-e635fe3b-9697-4b8b-884b-c0cc0c122f44.gif)

</br>
</br>

------

## PART 3. 컨베이어 벨트에서 센서들을 활용하여 불량여부 판단하고 분리하기 (모든 요소 결합하기)
![IMG_1840_MOV_AdobeExpress (1)](https://user-images.githubusercontent.com/110883172/210244377-fbb891e9-5cc8-4fd5-8e04-b115ca032478.gif)
### 동작 설명
A 아두이노가 컨베이어 벨트를 구동

카메라를 통해 원을 detection -> B아두이노에 데이터를 전달 -> 레이저센서에서 거리가 detection시 서보모터 작동

## PART 4. 데이터의 흐름 정리 및 AWS에 데이터 전송
### __목표__
- 아두이노와 노트북간의 통신과 같은 데이터의 흐름을 정의하고 정리한다.
- 아두이노의 멀티스레딩 환경 구현
- AWS에 데이터를 올리는 과정을 구현한다.



## PART 5. 플루터를 통한 모니터링 앱구현
![image](https://user-images.githubusercontent.com/110883172/210025846-926cf4e9-80f4-4ed4-a679-ada67d88445d.png)

- __목표__
  - 블루투스를 통해 컨베이어 벨트의 작동 및 중지 명령
  - 생산라인 상황을 실시간으로 모니터링 할 수 있는 시각화 자료 제공


#### PART 6. 언리얼엔진을 통한 디지털트윈 구현

- __목표__
  - 가상공간에 생산라인을 구현하여 가상공간에서 실시간 모니터링
