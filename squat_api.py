from flask import Flask, request, jsonify
import numpy as np
from tensorflow.keras.models import load_model
import h5py as h5

model = h5.File('Sequential_model.h5', 'r')
app = Flask(__name__)
model = load_model(model)  

@app.route('/predict', methods=['POST'])
def predict():
    data = request.get_json(force=True)
    input_data = np.array(data)
    predictions = model.predict(input_data)
    return jsonify(predictions.tolist())

if __name__ == '__main__':
    app.run(debug=True)
