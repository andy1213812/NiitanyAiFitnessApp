import cv2 
import mediapipe as mp
import numpy as np
import pandas as pd
from openpyxl import Workbook
mp_drawing = mp.solutions.drawing_utils
mp_pose = mp.solutions.pose
connection_drawing_spec = mp_drawing.DrawingSpec(color=(255, 255, 0), thickness=10, circle_radius=2)
landmark_drawing_spec = mp_drawing.DrawingSpec(color=(0, 0, 255), thickness=10, circle_radius=5)




cam = cv2.VideoCapture(0)
# cam.set(3, 100)
# cam.set(4, 100)
number_of_images = 50
current_images = 0


with mp_pose.Pose(min_detection_confidence=0.5, min_tracking_confidence=0.5) as pose:
    

    while current_images < number_of_images:
        ret , frame = cam.read() # frame_flag return a boolean to indicate is access is success or not
        
        if not ret:
            print("Failed to capture image")
            break

        image = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        image.flags.writeable = False # lock array

        # Make detection by using pretrained model
        results = pose.process(image)

        image.flags.writeable = True # unlock array
        image = cv2.cvtColor(image, cv2.COLOR_RGB2BGR)

        if results.pose_landmarks != None:
            mp_drawing.draw_landmarks(image, 
                                  results.pose_landmarks, 
                                  mp_pose.POSE_CONNECTIONS,
                                  connection_drawing_spec=connection_drawing_spec,
                                  landmark_drawing_spec = landmark_drawing_spec)
            cv2.imwrite(f'/Users/jackliu/Documents/GitHub/NiitanyAiFitnessApp/computer_vision/incorrect_image/squat_correct_IMAGE_{current_images}.png', image)
            current_images += 1
        
        cv2.imshow('Cam', image)

        if cv2.waitKey(50) == ord('q'):
            break

    cam.release()
    cv2.destroyAllWindows()











    