import numpy as np
import tensorflow as tf
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import LSTM, Dense

# Sample data (time series)
data = np.random.randn(100, 10)  # 100 sequences of length 10
labels = np.random.randint(0, 2, size=(100,))  # Binary labels

print(data)
print(labels)

# Reshape data for LSTM input (samples, time steps, features)
data = data.reshape((data.shape[0], 1, data.shape[1]))

print(data)

# Define LSTM model
model = Sequential(
    [
        LSTM(64, input_shape=(1, 10)),  # 64 LSTM units
        Dense(1, activation="sigmoid"),  # Output layer with sigmoid activation
    ]
)

# Compile the model
model.compile(optimizer="adam", loss="binary_crossentropy", metrics=["accuracy"])

# Train the model
model.fit(data, labels, epochs=10, batch_size=32)
