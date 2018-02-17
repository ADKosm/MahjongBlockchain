import os

import inject

from mahjong.core.blockchain_gateway import BlockchainGateway
from mahjong.core.game_orchestrator import GameOrchestrator


class Initiator:
    @staticmethod
    def inject_config(binder):
        url = os.environ.get("BLOCKCHAIN_URL", "http://localhost:8545")
        binder.bind(GameOrchestrator, GameOrchestrator())
        binder.bind(BlockchainGateway, BlockchainGateway(url=url))

    def boot_application(self):
        inject.configure(self.inject_config)

        gateway = inject.instance(BlockchainGateway)
        with open('mahjong/contracts/mahjong_contract.sol', 'rb') as contract_file:
            contract = contract_file.read()
            gateway.upload_contract(contract)
