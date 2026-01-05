from flask import Flask, jsonify

app = Flask(__name__)

@app.get("/healthz")
def healthz():
    return jsonify(status="ok"), 200

@app.get("/")
def index():
    return jsonify(message="hello"), 200
