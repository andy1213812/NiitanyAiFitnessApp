import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
import tensorflow as tf
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import LSTM, Dense
from tensorflow.keras.optimizers import Adam

# Load datasets
correct_squat_1 = pd.read_excel('Clean_Dataset/Correct_Squat_1.xlsx')
correct_squat_2 = pd.read_excel('Clean_Dataset/Correct_Squat_2.xlsx')
incorrect_squat_1 = pd.read_excel('Clean_Dataset/Incorrect_Squat_1.xlsx')
incorrect_squat_2 = pd.read_excel('Clean_Dataset/Incorrect_Squat_2.xlsx')

datasets = [correct_squat_1, correct_squat_2, incorrect_squat_1, incorrect_squat_2]
labels = [1, 1, 0, 0]  

def extract_features_and_labels(datasets, labels):
    features_list = []
    labels_list = []
    for dataset, label in zip(datasets, labels):
        for rep in dataset['Rep'].unique():
            rep_data = dataset[dataset['Rep'] == rep]
            # Here we calculate the mean of each column as an example feature
            features = rep_data.mean().drop(['Rep']).values
            features_list.append(features)
            labels_list.append(label)
    return np.array(features_list), np.array(labels_list)

features, labels = extract_features_and_labels(datasets, labels)

# Data scaling
scaler = StandardScaler()
features_scaled = scaler.fit_transform(features)

# Reshape features for LSTM input
features_scaled = features_scaled.reshape((features_scaled.shape[0], 1, features_scaled.shape[1]))

# Split the data
X_train, X_test, y_train, y_test = train_test_split(features_scaled, labels, test_size=0.2, random_state=42)

# LSTM Model
model = Sequential([
    LSTM(50, activation='relu', input_shape=(1, features_scaled.shape[2])),
    Dense(1, activation='sigmoid')
])

model.compile(optimizer=Adam(learning_rate=0.001), loss='binary_crossentropy', metrics=['accuracy'])

# Train the model
history = model.fit(X_train, y_train, epochs=100, validation_split=0.2, verbose=1)

# Evaluate the model
test_loss, test_accuracy = model.evaluate(X_test, y_test, verbose=1)
print(f"Test Accuracy: {test_accuracy*100:.2f}%")

model.save('LSTM.h5')



