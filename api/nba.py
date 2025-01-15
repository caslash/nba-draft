from flask import Flask, request

app = Flask(__name__)

@app.route("/")
def hello_world():
    return { "message": "Hello, World" }

@app.route("/hello")
def hello():
    return { "message": f"Hello {request.args.get('name')}" }