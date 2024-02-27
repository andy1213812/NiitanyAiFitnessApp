import pandas as pd
import numpy as np
from keras.models import load_model
from sklearn.preprocessing import StandardScaler

df = pd.read_excel('Clean_DataSet/Incorrect_Squat_2.xlsx')

scaler = StandardScaler()
df_mean = df.mean().to_frame().T
features_scaled = scaler.fit_transform(df_mean)
model = load_model('Sequential_model.h5')
prediction = model.predict(features_scaled)
threshold = 0.8
set_quality = "Good" if prediction >= threshold else "Bad"
probability = prediction[0][0]

print(f"Set Quality: {set_quality}, Probability: {probability:.2f}")



