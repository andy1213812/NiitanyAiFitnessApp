import pandas as pd
import numpy as np
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import LSTM, Dense
from tensorflow.keras.optimizers import Adam
from sklearn.preprocessing import MinMaxScaler

# Assuming the paths are correctly set to your Excel files
data_path = '/Users/andychen/Desktop/NiitanyAiFitnessApp/Clean_DataSet/Correct_Squat_1.xlsx'
data2_path = '/Users/andychen/Desktop/NiitanyAiFitnessApp/Clean_DataSet/Incorrect_Squat_1.xlsx'

# Load data
data = pd.read_excel(data_path).head(100)
data2 = pd.read_excel(data2_path).head(100)

# Drop the first column (assuming it's an index or non-relevant feature)
data = data.iloc[:, 1:]
data2 = data2.iloc[:, 1:]

# Set column names
columns = ["time", "rotation_x", "rotation_y", "rotation_z", "acceleration_x", "acceleration_y", "acceleration_z"]
data.columns = columns
data2.columns = columns

# Add outcome column
data['outcome'] = 1
data2['outcome'] = 0

# Combine data
training_data = pd.concat([data, data2], ignore_index=True)

# Normalize data except for the 'time' column
scaler = MinMaxScaler()
training_data.iloc[:, 1:-1] = scaler.fit_transform(training_data.iloc[:, 1:-1])

# Convert the dataframe to a 3D array for LSTM
def to_lstm_input(data, look_back=1):
    X = np.zeros((len(data) - look_back, look_back, data.shape[1]-1))
    for i in range(len(data) - look_back):
        X[i] = data.iloc[i:(i + look_back), :-1].values
    return X

x_data = to_lstm_input(training_data.drop(columns=['time']), look_back=1)
y_data = training_data['outcome'].values[1:]  # Adjust to match x_data structure

# Building the LSTM model
LSTM_model = Sequential([
    LSTM(units=50, input_shape=(1, 6), activation='sigmoid'),
    Dense(units=1, activation='sigmoid')
])

LSTM_model.compile(loss='binary_crossentropy', optimizer=Adam(), metrics=['accuracy'])

# Train the model
history = LSTM_model.fit(x_data, y_data, epochs=100, batch_size=32, validation_split=0.2)
model_path = 'LSTM.h5'
LSTM_model.save(model_path)