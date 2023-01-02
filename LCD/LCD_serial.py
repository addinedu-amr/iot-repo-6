import sys
import numpy as np
import cv2

import serial
import time

cap = cv2.VideoCapture(0)
if not cap.isOpened():
    print("열리지 않아요")
    sys.exit()

ser = serial.Serial('/dev/ttyACM0', 9600)
count = 0
de_count = 0 
radius_list = []

while True:
    ret, frame = cap.read()
    if not ret:
        break

    #src = cv2.resize(frame, dsize=(900, 959))
    # 이미지의 사이즈를 조절한다.

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
        #for i in range(circles.shape[1]):
        # 검출된 원의 개수만큼 돌아서 원을 그린다.
        cx, cy, radius = circles[0][0]
        cv2.circle(dst, (int(cx), int(cy)), int(radius), (255, 0, 0), 2, cv2.LINE_AA)
        cv2.putText(dst, str(radius), org=(int(cx), int(cy)), 
        fontFace=cv2.FONT_HERSHEY_SIMPLEX, fontScale=1, 
        color=(0,0,255),thickness=3, lineType=cv2.LINE_AA)
        radius_list.append(radius)
        count += 1
        if count == 5:
            val_radius = np.average(radius_list)
            if val_radius >=38 and val_radius <= 42:
                val = "circle, "+ "yes, " + str(val_radius) +  "/"
            else:
                val = "circle, "+ "no, " + str(val_radius) +  "/"
            val = val.encode('utf-8')
            ser.write(val)
            radius_list.clear()
            count = 0   
        de_count = 0 
        time.sleep(0.1)
    
    else:
        de_count += 1
        if de_count == 5:
            val = "not detect           "
            val = val.encode('utf-8')
            ser.write(val)
            de_count = 0
            count = 0

        time.sleep(0.25)
        count = 0 
        
    
    

    cv2.imshow('img', dst)
    key = cv2.waitKey(1)

    if key == 27:
        break
    


cap.release()
cv2.destroyAllWindows()