import json

import inject

from mahjong.core.blockchain_gateway import BlockchainGateway
from mahjong.core.game_map import GameMap


class GameOrchestrator:
    gateway = inject.attr(BlockchainGateway)

    def say_hello(self):
        self.gateway._run_volatile_contract_method('setGreeting', "Nihao")
        g = self.gateway._run_immutable_contract_method('greet')
        return json.dumps(g)

    def create_game(self) -> str:
        pass

    def step(self, id, new_game_map) -> GameMap:
        pass

    def back_to(self, id, timestamp) -> GameMap:
        pass

    def get_current(self, id) -> GameMap:
        pass
