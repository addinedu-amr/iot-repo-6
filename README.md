# 스마트 팩토리 ( smart factory )
![smartfactory](https://user-images.githubusercontent.com/110883172/210024375-fc7a94e9-afea-4a4e-bf34-c167016dacc8.png)


## 개요
### 문제인식
- 자동화된 생산라인에서 어떻게 하면 수율을 올릴 수 있을까?
- 자동화된 생산라인에서 어떻게 하면 안정성을 높일 수 있을까?
- 자동화된 생산라인과 IOT는 어떻게 접목될 수 있을까?


### 전략
- 수율을 올리기 위해서는 정확한 불량여부 판단이 필요할 것이다.
- 안정성을 높이기 위해서는 자동화된 생산라인에 작업자의 접근을 차단해야한다.
- 작업자가 외부에서 스마트 기기를 이용해 공장 내부의 상황을 실시간으로 모니터링 할 수 있게 하자.


## 프로젝트 설계도 및 배치
![블록선도 drawio](https://user-images.githubusercontent.com/110883172/210239215-edd5acf7-f9e5-409b-80ea-1aa23dc0c62a.png)


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

#### PART 2. 생산품의 불량여부 판단 및 데이터 처리 (김두엽, 류도현, 정재욱, 이미영)

- __OpenCV 허프변환을 통한 원검출 
![image](https://user-images.githubusercontent.com/110883172/210025302-9d2c4a95-28b3-4ba2-8281-3070f7a806d5.png)


- __원을 검출하여 불량여부를 판단하여 LCD에 출력하는 코드__
  - 아무것도 detect하지 못한 경우
![image](https://user-images.githubusercontent.com/110883172/210025515-d03b7048-abc9-4d81-a730-8ba54c58725a.png)

  - 도형의 종류, 불량여부, 반지름을 LCD에 표시 (100원인 경우 정상)
![image](https://user-images.githubusercontent.com/110883172/210025647-1f08647d-9336-4a2a-9b81-53e454ce846e.png)

  - 500원인 경우 불량으로 판단
![image](https://user-images.githubusercontent.com/110883172/210025666-1cc47ecb-6340-437b-94d5-3d9c870d2431.png)

  - 컨베이어 벨트에서의 detection 실험

![20221229_160249_AdobeExpress](https://user-images.githubusercontent.com/110883172/210025770-25e307ee-be0a-4042-a48b-423a29842805.gif)


  - 판단데이터는 AWS에 저장


#### PART 3. 플루터를 통한 모니터링 앱구현 (조이삭, 정재욱)
![image](https://user-images.githubusercontent.com/110883172/210025846-926cf4e9-80f4-4ed4-a679-ada67d88445d.png)

- __목표__
  - 블루투스를 통해 컨베이어 벨트의 작동 및 중지 명령
  - 생산라인 상황을 실시간으로 모니터링 할 수 있는 시각화 자료 제공


#### PART 4. 언리얼엔진을 통한 생산라인의 디지털트윈 구현  (류도현, 정재욱, 이미영)

- __목표__
  - 가상공간에 생산라인을 구현하여 가상공간에서 실시간 모니터링








