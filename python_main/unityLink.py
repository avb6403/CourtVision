import numpy as np
from numpysocket import NumpySocket
import struct
import cv2
from project_constants import *

def get_frame(client, coords):
    unity_recv = np.empty((H, W, 3), dtype = np.uint8)
    img = np.empty((H, W, 3), dtype = np.uint8)

    pose = [W, H, coords.Z, coords.X, -coords.Y, 0, 0, 0, UNITY_BALL]
    unity_buf = bytearray(struct.pack("%sf" % len(pose), *pose))
    client.send(unity_buf)
    client.recv_into(unity_recv, W*H*3)

    pose = [W, H, 0, CAM1_OFFSET, -CAMERA_HEIGHT, 90, -90, 0, UNITY_CAM1]
    unity_buf = bytearray(struct.pack("%sf" % len(pose), *pose))
    client.send(unity_buf)
    client.recv_into(unity_recv, W*H*3)
    gray_l = cv2.cvtColor(unity_recv, cv2.COLOR_BGR2GRAY)

    pose = [W, H, 0, CAM2_OFFSET, -CAMERA_HEIGHT, 90, -90, 0, UNITY_CAM2]
    unity_buf = bytearray(struct.pack("%sf" % len(pose), *pose))
    client.send(unity_buf)
    client.recv_into(unity_recv, W*H*3)
    gray_r = cv2.cvtColor(unity_recv, cv2.COLOR_BGR2GRAY) #images are actually flipped coming from Unity, I skipped that part cause it's slow

    return gray_l, gray_r