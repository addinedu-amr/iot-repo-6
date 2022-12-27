import sys
import numpy as np
import cv2

src = cv2.imread('./coin2.jpg')
# 이미지를 읽어온다.

if src is None:
    print('Image open failed!')
    sys.exit()
# 이미지가 없으면 실행하고 종료

src = cv2.resize(src, dsize=(900, 959))
# 이미지의 사이즈를 조절한다.

gray = cv2.cvtColor(src, cv2.COLOR_BGR2GRAY)
blr = cv2.GaussianBlur(gray, (0, 0), 1.0)
# 이미지의 잡음을 제거한다.

# 트렉바를 정의한다.
def on_trackbar(pos):
    rmin = cv2.getTrackbarPos('minRadius', 'img')
    rmax = cv2.getTrackbarPos('maxRadius', 'img')
    th = cv2.getTrackbarPos('threshold', 'img')
    
    # 실질적인 허프변환이 시작되는 부분
    circles = cv2.HoughCircles(blr, cv2.HOUGH_GRADIENT, 1, 50, param1=120, param2=th, minRadius=rmin, maxRadius=rmax)
    # 반지름과 threshold를 조절하면서 확인해볼 분이다.

    dst = src.copy()
    # 이미지를 복사해서 dst에 저장한다.
    
    # 원을 검출할 때 실행된다.
    if circles is not None:
        for i in range(circles.shape[1]):
        # 검출된 원의 개수만큼 돌아서 원을 그린다.
            cx, cy, radius = circles[0][i]
            cv2.circle(dst, (int(cx), int(cy)), int(radius), (255, 0, 0), 2, cv2.LINE_AA)
            if radius >= 40 and radius <= 46:
                cv2.putText(dst, "10", org=(int(cx), int(cy)), 
                        fontFace=cv2.FONT_HERSHEY_SIMPLEX, fontScale=1, 
                        color=(0,0,255),thickness=3, lineType=cv2.LINE_AA)
            
            elif radius >= 52 and radius <= 55:
                cv2.putText(dst, "50", org=(int(cx), int(cy)), 
                        fontFace=cv2.FONT_HERSHEY_SIMPLEX, fontScale=1, 
                        color=(0,0,255),thickness=3, lineType=cv2.LINE_AA)
            
            elif radius >= 57 and radius <= 62:
                cv2.putText(dst, "100", org=(int(cx), int(cy)), 
                        fontFace=cv2.FONT_HERSHEY_SIMPLEX, fontScale=1, 
                        color=(0,0,255),thickness=3, lineType=cv2.LINE_AA)
            
            elif radius >= 63 and radius <= 68:
                cv2.putText(dst, "500", org=(int(cx), int(cy)), 
                        fontFace=cv2.FONT_HERSHEY_SIMPLEX, fontScale=1, 
                        color=(0,0,255),thickness=3, lineType=cv2.LINE_AA)
    cv2.imshow('img', dst)

# 트랙바 생성
cv2.imshow('img', src)
cv2.createTrackbar('minRadius', 'img', 0, 100, on_trackbar)
cv2.createTrackbar('maxRadius', 'img', 0, 150, on_trackbar)
cv2.createTrackbar('threshold', 'img', 0, 100, on_trackbar)
cv2.setTrackbarPos('minRadius', 'img', 10)
cv2.setTrackbarPos('maxRadius', 'img', 80)
cv2.setTrackbarPos('threshold', 'img', 40)
cv2.waitKey()
cv2.destroyAllWindows()