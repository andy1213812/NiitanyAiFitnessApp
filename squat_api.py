from flask import Flask, request, jsonify
from keras.models import load_model
import numpy as np
import pandas as pd
from sklearn.preprocessing import StandardScaler

app = Flask(__name__)
model = load_model('LSTM.h5')

data_path = 'Clean_Dataset/Correct_Squat_1.xlsx'


@app.route('/predict', methods=['POST','GET'])
def predict():
    try:
        json_ = data_path
        query_df = pd.DataFrame(json_)
        scaler = StandardScaler()
        query = scaler.fit_transform(query_df)
        prediction = model.predict(query)
        return jsonify({'prediction': prediction.flatten().tolist()})
    except Exception as e:
        return jsonify({'error': str(e)})


if __name__ == '__main__':
    app.run(debug=True)
