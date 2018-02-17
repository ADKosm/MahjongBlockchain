import inject
from flask import Flask, send_from_directory

from mahjong.core.game_orchestrator import GameOrchestrator
from mahjong.initiator import Initiator

app = Flask(__name__)
initiator = Initiator()


@app.route('/api/sleep')
@inject.params(game_orchestrator=GameOrchestrator)
def api_sleep(game_orchestrator):
    return game_orchestrator.say_hello()


@app.route('/')
def index_alias():
    return send_from_directory('assets/web', 'index.html')


@app.route('/<path:path>')
def root_endpoint(path):
    return send_from_directory('assets/web', path)


initiator.boot_application()


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8484)
