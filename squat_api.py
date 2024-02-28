from flask import Flask, request, jsonify
from tensorflow.keras.models import load_model
import numpy as np

app = Flask(__name__)

model = load_model('LSTM.h5')

@app.route('/predict', methods=['POST'])
def predict():
    try:
        data = request.get_json(force=True)
        prediction_data = np.array(data['data'])
        prediction = model.predict(prediction_data).tolist()
        return jsonify({'prediction': prediction})
    except Exception as e:
        return jsonify({'error': str(e)})

if __name__ == '__main__':
    app.run(debug=True)

