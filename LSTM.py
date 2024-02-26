import pandas as pd
import numpy as np
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import LSTM, Dense
from tensorflow.keras.optimizers import Adam
from sklearn.preprocessing import MinMaxScaler

# Assuming the paths would be replaced with your actual file paths
data_path = '/path/to/your/correct/form/testing/data.xls'
data2_path = '/path/to/your/training/data/squat/incorrect/form/cleaned.csv'

# Reading the data
data = pd.read_excel(data_path).head(100)
data2 = pd.read_csv(data2_path).head(100)

# Renaming columns
columns = ["rep", "time", "rotation_x", "rotation_y", "rotation_z", "acceleration_x", "acceleration_y", "acceleration_z"]
data.columns = columns
data2.columns = columns

# Assigning outcomes
data['outcome'] = 1
data2['outcome'] = 0

# Combining datasets
training_data = pd.concat([data, data2], ignore_index=True)

# Normalizing the data except for 'time' column
scaler = MinMaxScaler()
training_data.loc[:, training_data.columns != 'time'] = scaler.fit_transform(training_data.loc[:, training_data.columns != 'time'])

# Function to convert data to 3D array for LSTM
def to_lstm_input(data, look_back=1):
    X = np.zeros((len(data) - look_back, look_back, data.shape[1]))
    for i in range(len(data) - look_back):
        X[i] = data[i:(i + look_back)]
    return X

# Preparing data for LSTM
x_data = to_lstm_input(training_data.drop(['time', 'outcome'], axis=1).values, look_back=1)
y_data = training_data['outcome'].values[1:]  # Adjusted to match x_data's structure

# Building the LSTM model
LSTM_model = Sequential([
    LSTM(units=50, input_shape=(1, 6)),
    Dense(units=1)
])

LSTM_model.compile(
    loss='mean_squared_error',
    optimizer=Adam(),
    metrics=['accuracy']
)

# Training the model
history = LSTM_model.fit(
    x_data, y_data,
    epochs=100,
    batch_size=32,
    validation_split=0.2
)
