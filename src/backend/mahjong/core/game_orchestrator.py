import json
import uuid

import inject

from mahjong.core.blockchain_gateway import BlockchainGateway
from mahjong.core.game_map import GameMap


class GameOrchestrator:
    gateway = inject.attr(BlockchainGateway)

    @staticmethod
    def map_template(map_type):
        return {
            'cube': 'mahjong/game_maps/cube.json'
        }.get(map_type)

    def create_game(self, map_path) -> str:
        new_game_id = str(uuid.uuid4())
        initial_map = GameMap.load_from_file(map_path)
        self.gateway.inject_step(new_game_id, initial_map)
        return new_game_id

    def step(self, id, new_game_map: str) -> GameMap:
        game_map = GameMap.load_from_parameters(new_game_map, -1)
        self.gateway.commit_step(id, game_map)
        return game_map

    def back_to(self, id, timestamp: int) -> GameMap:
        game_map = self.gateway.find_by_timestamp(id, timestamp)
        if not game_map:
            raise Exception("Can't find these version of map")
        self.gateway.inject_step(id, game_map)
        return game_map

    def get_current(self, id) -> GameMap:
        return self.gateway.get_current_map(id)
