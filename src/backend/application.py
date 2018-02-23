import inject
from flask import Flask, send_from_directory, request, jsonify

from mahjong.core.game_orchestrator import GameOrchestrator
from mahjong.initiator import Initiator

app = Flask(__name__)
initiator = Initiator()


@app.route('/api/new_game', methods=['GET', 'POST'])
@inject.params(game_orchestrator=GameOrchestrator)
def api_new_game(game_orchestrator):
    game_template = GameOrchestrator.map_template('cube')  # TODO: make parametrized
    game_id = game_orchestrator.create_game(game_template)
    return jsonify({
        'game_id': game_id
    })


@app.route('/api/step', methods=['GET', 'POST'])
@inject.params(game_orchestrator=GameOrchestrator)
def api_step(game_orchestrator):
    game_id = request.args.get('game_id', request.form.get('game_id'))
    new_map = request.args.get('new_map', request.form.get('new_map'))
    game_orchestrator.step(game_id, new_map)
    return jsonify({'status': 'ok'})


@app.route('/api/back_to', methods=['GET', 'POST'])
@inject.params(game_orchestrator=GameOrchestrator)
def api_back_to(game_orchestrator):
    game_id = request.args.get('game_id', request.form.get('game_id'))
    step_timestamp = max(1, int(request.args.get('step_timestamp', request.form.get('step_timestamp'))))
    game_map = game_orchestrator.back_to(game_id, step_timestamp)
    packed_map, packed_timestamp = game_map.pack()
    return jsonify({
        'game_map': packed_map,
        'timestamp': packed_timestamp
    })


@app.route('/api/get_current', methods=['GET', 'POST'])
@inject.params(game_orchestrator=GameOrchestrator)
def get_current(game_orchestrator):
    game_id = request.args.get('game_id', request.form.get('game_id'))
    game_map = game_orchestrator.get_current(game_id)
    packed_map, packed_timestamp = game_map.pack()
    return jsonify({
        'game_map': packed_map,
        'timestamp': packed_timestamp
    })


@app.route('/')
def index_alias():
    return send_from_directory('assets/web', 'index.html')


@app.route('/<path:path>')
def root_endpoint(path):
    return send_from_directory('assets/web', path)


initiator.boot_application()


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8484)
