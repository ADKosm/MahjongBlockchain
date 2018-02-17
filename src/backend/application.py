from flask import Flask, send_from_directory

app = Flask(__name__)


@app.route('/')
def index_alias():
    return send_from_directory('assets/web', 'index.html')


@app.route('/<path:path>')
def root_endpoint(path):
    return send_from_directory('assets/web', path)

app.run(host="0.0.0.0", port=8484)
