# 스마트 팩토리 ( smart factory )
![smartfactory](https://user-images.githubusercontent.com/110883172/210024375-fc7a94e9-afea-4a4e-bf34-c167016dacc8.png)

- 스마트 팩토리란? 설계 및 개발, 제조 및 유통 등 생상과정에 디지털 자동화 솔루션을 결합한 지능형 생산 공장
- 공장 내 설비와 기계에 사물인터넷을 설치하여 공정 데이터를 실시간으로 수집하고, 이를 분석해 스스로 제어할 수 있게 만든 미래의 공장입니다.


</br>
</br>

## 개요

### 발표자료 및 시연 영상
![image](https://user-images.githubusercontent.com/110883172/211439396-2ce56802-9e20-46ca-9db0-7f405db29c80.png)
![image](https://user-images.githubusercontent.com/110883172/211439416-50c2c309-a860-4e1f-a628-9da70a52a696.png)
![image](https://user-images.githubusercontent.com/110883172/211439436-571dcb5e-8bb7-4ab1-b08d-136861df767c.png)

https://drive.google.com/drive/u/1/folders/1S4-qjXNvgSVtVAN566lB0PACdmTJGy4S



### 문제인식
- 자동화된 생산라인에서 어떻게 하면 수율을 올릴 수 있을까?
- 자동화된 생산라인에서 어떻게 하면 안정성을 높일 수 있을까?
- 자동화된 생산라인과 IOT는 어떻게 접목될 수 있을까?


</br>


### 전략
#### 스마트 팩토리에 꼭 필요한 요소
- 생산라인의 자동화, 무인화
- 데이터를 수집하여 기계가 스스로 판단
- 언제 어디서든 모니터링 가능한 환경


#### 구체화

__1. 자동화, 무인화__
- 영상처리를 활용해 제품의 불량여부 검출 및 분류
- 작업자의 접근을 막는 안전장치 사용

__2. 데이터를 수집하여 기계가 스스로 판단__
- 타이어의 크기만 분류하므로 딥러닝이 아닌 OpenCV를 사용
- 영상처리한 데이터는 데이터베이스에 저장

__3. 언제 어디서든 모니터링 가능한 환경 구축__
- 앱을 통해 실시간으로 생산라인을 모니터링
- 앱을 통해 생산라인의 작동을 제어
- 디지털 트윈을 사용해 가상환경에서 생산라인 모니터링

</br>
</br>


## 프로젝트 설계도 및 배치
# 제어흐름도
![블록선도 drawio](https://user-images.githubusercontent.com/110883172/210239215-edd5acf7-f9e5-409b-80ea-1aa23dc0c62a.png)

# 회로도
![image](https://user-images.githubusercontent.com/110883172/210605920-f79bfb4e-cfbb-4264-bb08-c316c64e3b4d.png)


</br>
</br>


## 역할 분담
#### 정재욱 
###### 총괄
- 프로젝트 기획 및 물품구매
- 각 센서들의 동작을 구현
- 노션관리

#### 김두엽
###### 하드웨어 팀장
- 하드웨어 설계 및 구현
- 데이터 흐름 구체화(제어흐름도 작성
- 깃 관리

#### 류도현
###### 디지털 트윈 팀장
- 언리얼 엔진을 통한 디지털 트윈 설계 및 구현
- 데이터 베이스와 언리얼 엔진 연동
- 하드웨어 디자인 설계

#### 이미영
###### 데이터 팀장
- 각 파츠별 주고받는 데이터 정의
- 데이터 베이스 관리 및 여러 모듈과의 연동 구현
- Notion 기록 담당

#### 조이삭
###### 앱 팀장
- 프로젝트 제어, 모니터링용 앱 개발
- 프로젝트 전체적인 디자인 개발
- Notion 기록 담당


</br>
</br>


-------

## PART 1. 물품구매와 각 센서들의 동작 구현

### 필요물품 및 프로그램 정리

![image](https://user-images.githubusercontent.com/110883172/211437056-6bf07fd4-416b-4eaa-b487-209fdb2d49ba.png)

</br>
</br>

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

- 알고리즘
![image](https://user-images.githubusercontent.com/110883172/211437154-dd6d2c16-04ae-410b-bf24-7615667f274a.png)


</br>
</br>

------

## PART 3. 컨베이어 벨트에서 센서들을 활용하여 불량여부 판단하고 분리하기 (모든 요소 결합하기)
![image](https://user-images.githubusercontent.com/110883172/211437722-706076f5-71a0-4802-9bb4-aea682b24db3.png)


#### 완성된 하드웨어의 모습
![image](https://user-images.githubusercontent.com/110883172/211437362-7def3ac0-18da-4286-b974-4f0a3ee23666.png)
-컨베이어를 구동하는 아두이노와 서보모터를 동작해 물품을 분류하는 아두이노로 구성됨.


### 동작 설명
A 아두이노가 컨베이어 벨트를 구동

카메라를 통해 원을 detection -> B아두이노에 데이터를 전달 -> 레이저센서에서 거리가 detection시 서보모터 작동




## PART 4. 데이터의 흐름 정리 및 firebase에 데이터 전송
### __목표__
- 아두이노와 노트북간의 통신과 같은 데이터의 흐름을 정의하고 정리한다.
- 아두이노의 멀티스레딩 환경 구현 - 파이썬
- firebase에 데이터를 올리는 과정을 구현한다. https://firebase.google.com/
  (기획시 Cloud로 AWS를 사용하려 했으나 flutter 앱과 연결을 구현하기 어려워 파이어베이스로 수정)
![image](https://user-images.githubusercontent.com/84861457/210312837-9d389f43-4280-4252-af22-61cae5f61dc8.png)

### __구현과정__
- 우선 가상환경에 firebase_admin을 pip로 다운로드 하여야 한다.

```python
import firebase_admin

from firebase_admin import credentials
from firebase_admin import firestore
from firebase_admin import db

cred = credentials.Certificate("json파일 위치 지정")
firebase_admin.initialize_app(cred, {
 'databaseURL' : "데이터 베이스 주소"
})
db = firestore.client()

doc_ref = db.collection(u'err_rate').document(str(T))
doc_ref.set(({u'rate': R, u'trial': T})) 
```

- 다음의 코드를 활용하여 데이터를 올린다.

### 프로젝트에 사용하는 데이터

![Untitled](https://user-images.githubusercontent.com/110883172/211438632-9f98d8b6-8542-4bdd-97b2-5cfe7136cf52.png)
![Untitled (1)](https://user-images.githubusercontent.com/110883172/211438633-fca4512f-a489-46a3-ae30-da33454b9d48.png)
![Untitled (2)](https://user-images.githubusercontent.com/110883172/211438634-4abaf3f1-ef26-45c4-b670-2b0d63464072.png)
![Untitled (3)](https://user-images.githubusercontent.com/110883172/211438636-95244d92-48c0-4774-9eb6-a54b1f0320b2.png)



## PART 5. 플루터를 통한 모니터링 앱구현
![image](https://user-images.githubusercontent.com/110883172/210025846-926cf4e9-80f4-4ed4-a679-ada67d88445d.png)

### __목표__
  - 블루투스를 통해 컨베이어 벨트의 작동 및 중지 명령
  - 생산라인 상황을 실시간으로 모니터링 할 수 있는 시각화 자료 제공

### 앱 UI
#### 처음 시작화면
![Untitled (4)](https://user-images.githubusercontent.com/110883172/211438795-5640b4b7-6a5f-41ec-a9ff-6c07489e319c.png)
- 블루투스를 통해 컨베이어 벨트 아두이노와 통신한다.

#### 메인화면
![Untitled (6)](https://user-images.githubusercontent.com/110883172/211438852-fdfe126d-4cbb-42ec-9cf2-5d8e8eb8dd4a.png)
- 컨베이어 벨트를 작동 시키거나 정지시킬 수 있다.

![Untitled (9)](https://user-images.githubusercontent.com/110883172/211439020-03391b2e-a2b2-4b99-8dc7-b1aef4c26c49.png)
- 사람의 동작을 감지한 경우 (초음파 센서)

#### 시각화 데이터
- 메인화면에서 실시간 데이터 버튼을 클릭하면 다음과 같은 화면이 나온다.
![Untitled (7)](https://user-images.githubusercontent.com/110883172/211438934-8e5dcc76-a070-4c96-baeb-402609912752.png)
![Untitled (8)](https://user-images.githubusercontent.com/110883172/211438941-326d8297-91bf-49ec-83a0-5a0dad4a22ad.png)



#### PART 6. 언리얼엔진을 통한 디지털트윈 구현

### 목표
  - 가상공간에 생산라인을 구현하여 가상공간에서 실시간 모니터링


### 구현 과정


### 시연 영상
<center><img src="https://i9.ytimg.com/vi/k923l4ppG8k/mq1.jpg?sqp=CMiI850G&rs=AOn4CLAYfAe76Va4jtcI4K45R8svbXxoqQ" width="400" height="200"/></center>(https://youtu.be/k923l4ppG8k)
