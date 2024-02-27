from flask import Flask, request, jsonify
from keras.models import load_model
import numpy as np
import pandas as pd
from sklearn.preprocessing import StandardScaler

app = Flask(__name__)
model = load_model('Sequential_model.h5')

model = load_model(model)  

@app.route('/predict', methods=['POST'])
def predict():
    try:
        json_ = request.json
        query_df = pd.DataFrame(json_)
        scaler = StandardScaler()
        query = scaler.fit_transform(query_df)
        prediction = model.predict(query)
        return jsonify({'prediction': prediction.flatten().tolist()})
    except Exception as e:
        return jsonify({'error': str(e)})


if __name__ == '__main__':
    app.run(debug=True)
