import pandas as pd
from sklearn.preprocessing import StandardScaler
from keras.models import load_model

# Load the DataFrame from the Excel file
df = pd.read_excel('Clean_DataSet/Correct_Squat_2.xlsx')

# Select the correct 7 features used during the model's training
# Adjust these indices to match the features your model was trained on
selected_features = df.iloc[:, [0, 1, 2, 3, 4, 5, 6]].mean().to_frame().T  # Example feature selection

# Prepare the data
scaler = StandardScaler()
features_scaled = scaler.fit_transform(selected_features)

# Reshape your features to include the time step dimension expected by LSTM
features_scaled = features_scaled.reshape((1, 1, features_scaled.shape[1]))

# Load your model
model = load_model('LSTM.h5')  # Ensure the path is correct

# Make a prediction
prediction = model.predict(features_scaled)
threshold = 0.5
set_quality = "Good" if prediction >= threshold else "Bad"
probability = prediction[0][0]

print(f"Set Quality: {set_quality}, Probability: {probability:.2f}")





