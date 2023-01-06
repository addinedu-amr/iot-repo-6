import firebase_admin

from firebase_admin import credentials
from firebase_admin import firestore
from firebase_admin import db

import sys
import numpy as np
import cv2
import serial
import time

# 데이터 베이스 접속
cred = credentials.Certificate("/home/du/ws/opencv/circle_detecter/iot4-edc7f-firebase-adminsdk-yjs2p-6dec9154e2.json")
firebase_admin.initialize_app(cred, {
 'databaseURL' : "firebase-adminsdk-yjs2p@iot4-edc7f.iam.gserviceaccount.com"
})
db = firestore.client()


# 카메라 구동
cap = cv2.VideoCapture(0)
if not cap.isOpened():
    print("열리지 않아요")
    sys.exit()

# 시리얼 통신 정의
ser = serial.Serial('/dev/ttyACM0', 9600)

# 원을 디텍션 할 때 사용하는 변수
count = 0
de_count = 0
# 반지름
radius_list = []

munjang = "not detect"

R = 255
G = 255
B = 255
# 새로운 원을 받아 들일 수 있는 상태인가요
new_circle_detect = True

# 미영님 추가 Cloud 변수
total_product = 0
total_fail = 0
total_pass = 0
error_rate = 0.
tri = 0 
ROI_ = ""

time.sleep(0.5)





    #input firebase Cloud
def error_input_DB(R,T):
    doc_ref = db.collection(u'err_rate').document(str(T))
    doc_ref.set(({u'rate': R, u'trial': T}))

def product_input_DB(total, passed, failed):
    doc_ref = db.collection(u'product').document(str(1))
    doc_ref.set(({u'총생산량': total, u'양품': passed, u'불량품' : failed}))

while True:
    ret, frame = cap.read()
    if not ret:
        break
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    blr = cv2.GaussianBlur(gray, (0, 0), 1.0)
    # 이미지의 잡음을 제거한다.
    # 실질적인 허프변환이 시작되는 부분
    circles = cv2.HoughCircles(blr, cv2.HOUGH_GRADIENT, 1, 50, param1=120, param2=40, minRadius=10, maxRadius=80)
    # 반지름과 threshold를 조절하면서 확인해볼 분이다.
    dst = frame.copy()
    # 이미지를 복사해서 dst에 저장한다.
    cv2.imshow('img', frame)
    # 원을 검출할 때 실행된다.


    if circles is not None:
        # 디텍션으로 넘어가야 문장에 출력이된다.
        cv2.putText(
                    dst, munjang, org=(0, 30),
                    fontFace=cv2.FONT_HERSHEY_SIMPLEX, fontScale=1,
                    color=(R,G,B),thickness=1, lineType=cv2.LINE_AA 
                    )
        # 원의 중심좌표, 반지름 읽어온다. (가장 먼저 detection한 원을 가져온다.)
        cx, cy, radius = circles[0][0]
        cv2.circle(
                    dst, 
                    (int(cx), int(cy)), int(radius), 
                    (255, 0, 0), 2, cv2.LINE_AA
                    )
        cv2.putText(dst, str(radius), org=(int(cx), int(cy)),
                    fontFace=cv2.FONT_HERSHEY_SIMPLEX, fontScale=1,
                    color=(0,0,255),thickness=3, lineType=cv2.LINE_AA)
        # detection한 반지름을 리스트에 저장한다.
        radius_list.append(radius)
        count += 1
        # 11개의 원이 검출된다. new_circle_detect 기존의 원이 사라지고 일정 시간 후 새로운 원이 들어왔는가?
        if count == 11 and new_circle_detect == True:
            # 평균을 구해서
            val_radius = np.average(radius_list) 
            new_circle_detect = False
            # 범위 이내에 있다면 양품으로 문장을 바꿔줘라.
            if np.average(radius_list) >= 15 and np.average(radius_list) <= 18:
                munjang = "pass  (" + str(np.average(radius_list)) + ")"
                val = "1/"
                R = 255
                G = 0
                B = 255
                # 5번 검출까지 ROI에 추가해 나갈 것임.
                ROI_ += "1"
                total_product += 1 
                total_pass += 1
            
            # 범위 밖이라면 불량이라 판단하자.
            else:
                munjang = "fail  (" + str(np.average(radius_list)) + ")"
                val = "0/"
                R = 0
                G = 0
                B = 255
                ROI_ += "0"
                total_product += 1 
                total_fail += 1
                
            # 시리얼 통신용
            val = val.encode('utf-8')
            ser.write(val)

            if len(ROI_) == 5:
                ROI_count = 0
                for i in range(len(ROI_)):
                    if ROI_[i] == '0': # 불량이 "0"
                        ROI_count += 1 
                
                error_rate = ROI_count / 5  * 100
                print("파이어베이스 체크용 -> 생성 개수 :" + str(len(ROI_)) + "  양품 개수 : " + str(5 - ROI_count) + "  실패 개수 : " + str(ROI_count) + "  5개 에러율 : " + str(error_rate) + "%" )     
                ROI_ = ""
                error_input_DB(error_rate, tri)
                tri += 1
            # 여기에 있는 변수를 파이어뭐시기에 올리시면 됩니다.
            print("총 개수 :" + str(total_product) + "  양품 총 개수 : " + str(total_pass) + "  실패 총 개수 : " + str(total_fail))
            product_input_DB(total_product, total_pass, total_fail)
            # 혹시 방금 데이터가 불량인지 아닌지 체크하고 싶으면 val(시리얼 통신용 변수) 변수가 1인지 ,0인지 체크하면됩니다.
            
            radius_list.clear()
            count = 0

        de_count = 0
        time.sleep(0.1)
    
    else:
        cv2.putText(dst, munjang, org=(0, 30),
                    fontFace=cv2.FONT_HERSHEY_SIMPLEX, fontScale=1,
                    color=(R,G,B),thickness=1, lineType=cv2.LINE_AA)
        new_circle_detect = True
        de_count += 1
        if de_count == 3:
            munjang = "not detect"
            R = 255
            G = 255
            B = 255
            de_count = 0
            count = 0
            radius_list.clear()
        time.sleep(0.1)

    cv2.imshow('img', dst)
    key = cv2.waitKey(1)
    if key == 27:
        break
cap.release()
cv2.destroyAllWindows()