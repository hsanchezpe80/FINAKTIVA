from flask import Flask, jsonify
import os
import time

app = Flask(__name__)
PORT = int(os.environ.get('PORT', 8080))

@app.route('/')
def home():
    return jsonify({
        'message': 'Worker Service funcionando',
        'timestamp': time.strftime('%Y-%m-%d %H:%M:%S')
    })

@app.route('/health')
def health():
    return jsonify({'status': 'UP'}), 200

@app.route('/api/process', methods=['POST'])
def process_task():
    # Simular procesamiento
    time.sleep(1)
    return jsonify({
        'status': 'success',
        'message': 'Tarea procesada exitosamente'
    }), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=PORT)