import numpy as np
import cv2
from project_constants import *

def get_binary(base, ball):
    binary = np.empty((H, W), dtype = np.uint8)

    cv2.bitwise_xor(base, ball, binary)

    return binary

def detect_circle(binary):
    ret,thresh = cv2.threshold(binary,127,255,cv2.THRESH_BINARY)

    circles = cv2.HoughCircles(thresh, cv2.HOUGH_GRADIENT, dp=1, minDist=1920, param1=2, param2=1, minRadius=2, maxRadius=6)
    
    if circles is not None:
        return circles[0,0,:]
    else:
        return [0]