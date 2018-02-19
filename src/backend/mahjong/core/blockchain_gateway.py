import time
from typing import Optional

from solc import compile_source
from web3 import Web3, HTTPProvider
from web3.contract import ConciseContract

from mahjong.core.game_map import GameMap


class BlockchainGateway:
    def __init__(self, url):
        self.blockchain_url = url
        self.eth_client = None
        self.gas = 4100000
        self.contract_instance = None
        self.polling_period = 0.5  # in seconds

    @property
    def w3(self):
        if not self.eth_client:
            self.eth_client = Web3(HTTPProvider(self.blockchain_url))
        return self.eth_client

    def commit_step(self, id: str, game_map: GameMap):
        """
        Timestamp incremented automaticly
        :param id:
        :param game_map:
        :return:
        """
        packed_map, _ = game_map.pack()
        self._run_volatile_contract_method('commitStep', self._bid(id), packed_map)

    def inject_step(self, id: str, game_map: GameMap):
        """
        Timestamp injected from passed parameter
        :param id:
        :param game_map:
        :return:
        """
        packed_map, timestamp = game_map.pack()
        self._run_volatile_contract_method('injectStep', self._bid(id), packed_map, timestamp)

    def find_by_timestamp(self, id: str, timestamp: int) -> Optional[GameMap]:
        startBlock = self.w3.eth.blockNumber
        for block in range(startBlock, -1, -1):
            current_timestamp = self._read_timestamp(id, block)
            if current_timestamp == timestamp:
                current_game_map = self._read_game_map(id, block)
                import pdb; pdb.set_trace()
                found_game_map = GameMap.load_from_parameters(current_game_map, current_timestamp)
                return found_game_map
        return None

    def get_current_map(self, id: str) -> GameMap:
        current_map = self._run_immutable_contract_method('getGameMap', self._bid(id))
        current_timestamp = self._run_immutable_contract_method('getTimestamp', self._bid(id))
        return GameMap.load_from_parameters(current_map, current_timestamp)

    def upload_contract(self, contract_source_code):
        time.sleep(5)  # Waiting for blockchain up

        contract_interface = self._compile_contract(contract_source_code)
        contract = self.w3.eth.contract(abi=contract_interface['abi'], bytecode=contract_interface['bin'])

        contract_hash = contract.deploy(transaction={'from': self.w3.eth.accounts[0], 'gas': self.gas})
        contract_receipt = self._wait_for_receipt(contract_hash)

        self.contract_address = contract_receipt['contractAddress']
        self.contract_instance = self.w3.eth.contract(
            contract_interface['abi'],
            self.contract_address,
            ContractFactoryClass=ConciseContract
        )

    # Private

    def _compile_contract(self, contract_source_code):
        compiled_sol = compile_source(contract_source_code)  # Compiled source code
        contract_interface = compiled_sol['<stdin>:Mahjong']
        return contract_interface

    def _wait_for_receipt(self, transaction_hash):
        transaction_receipt = None
        while not transaction_receipt:
            transaction_receipt = self.w3.eth.getTransactionReceipt(transaction_hash)
            time.sleep(self.polling_period)
        return transaction_receipt

    def _run_volatile_contract_method(self, method, *args):
        method_hash = getattr(self.contract_instance, method)(
            *args,
            transact={'from': self.w3.eth.accounts[0]}
        )
        method_receipt = self._wait_for_receipt(method_hash)
        return method_receipt

    def _run_immutable_contract_method(self, method, *args):
        result = getattr(self.contract_instance, method)(*args)
        return result

    def _bid(self, id: str):
        """
        :param id: uuid of 'Sting'
        :return:  bytes32
        """
        return Web3.toBytes(hexstr=Web3.sha3(text=id))

    def _position(self, id: str, index):
        """
        :param id: uuid of 'String'
        :param index: position in contract of 'Int'
        :return: int - position of value in contract
        """
        new_key = Web3.sha3(text=id) + '0' * 63 + str(index)
        new_position = Web3.toInt(hexstr=Web3.sha3(new_key))
        return new_position

    def _read_timestamp(self, id: str, block) -> int:
        timestamp_index = 0
        position = self._position(id, timestamp_index)
        result = Web3.toInt(self.w3.eth.getStorageAt(self.contract_address, position, block))
        return result

    def _read_game_map(self, id: str, block) -> str:
        game_map_index = 1
        position = self._position(id, game_map_index)
        result = Web3.toText(hexstr=self.w3.eth.getStorageAt(self.contract_address, position, block))
        return result
