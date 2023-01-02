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

munjang = "not detect"
R = 255
G = 255
B = 255

new_circle_detect = True

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
        cv2.putText(dst, munjang, org=(0, 30), 
        fontFace=cv2.FONT_HERSHEY_SIMPLEX, fontScale=1, 
        color=(R,G,B),thickness=1, lineType=cv2.LINE_AA)
        cx, cy, radius = circles[0][0]
        cv2.circle(dst, (int(cx), int(cy)), int(radius), (255, 0, 0), 2, cv2.LINE_AA)
        cv2.putText(dst, str(radius), org=(int(cx), int(cy)), 
        fontFace=cv2.FONT_HERSHEY_SIMPLEX, fontScale=1, 
        color=(0,0,255),thickness=3, lineType=cv2.LINE_AA)
        radius_list.append(radius)
        count += 1
        print(count)
        
        if count == 11 and new_circle_detect == True:
            val_radius = np.average(radius_list)
            new_circle_detect = False
            if np.average(radius_list) >= 25 and np.average(radius_list) <= 31:
                munjang = "pass  (" + str(np.average(radius_list)) + ")"
                val = "1/"
                #val = "pass," + str(np.average(radius_list))
                R = 255
                G = 0
                B = 255
            else:
                munjang = "fail  (" + str(np.average(radius_list)) + ")"
                val = "0/"
                #val = "fail," + str(np.average(radius_list))
                R = 0
                G = 0
                B = 255

            val = val.encode('utf-8')
            ser.write(val)
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