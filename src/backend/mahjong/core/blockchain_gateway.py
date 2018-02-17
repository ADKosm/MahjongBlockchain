import time

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

    @property
    def w3(self):
        if not self.eth_client:
            self.eth_client = Web3(HTTPProvider(self.blockchain_url))
        return self.eth_client

    def commit_step(self, id, game_map):
        pass

    def find_by_timestamp(self, id, timestamp) -> GameMap:
        pass

    def upload_contract(self, contract_source_code):
        print("Uploading smart-contract into blockchain", end='', flush=True)
        for i in range(5):
            print('.', end='', flush=True)
            time.sleep(1)  # waiting for geth launching
        print("", flush=True)

        compiled_sol = compile_source(contract_source_code)  # Compiled source code
        contract_interface = compiled_sol['<stdin>:Greeter']
        contract = self.w3.eth.contract(
            abi=contract_interface['abi'],
            bytecode=contract_interface['bin']
        )

        tx_hash = contract.deploy(
            transaction={'from': self.w3.eth.accounts[0], 'gas': self.gas}
        )
        print("Transation hash: {}".format(tx_hash), flush=True)

        tx_receipt = None
        print("Waiting for mining transaction", end="", flush=True)
        while not tx_receipt:
            print(".", end="", flush=True)
            tx_receipt = self.w3.eth.getTransactionReceipt(tx_hash)
            time.sleep(0.5)
        print("success!")

        contract_address = tx_receipt['contractAddress']
        self.contract_instance = self.w3.eth.contract(
            contract_interface['abi'],
            contract_address,
            ContractFactoryClass=ConciseContract
        )

    def _run_volatile_contract_method(self, method, *args):
        method_hash = getattr(self.contract_instance, method)(
            *args,
            transact={'from': self.w3.eth.accounts[0]}
        )

        method_receipt = None
        while not method_receipt:
            method_receipt = self.w3.eth.getTransactionReceipt(method_hash)
            time.sleep(0.5)

        return method_receipt

    def _run_immutable_contract_method(self, method, *args):
        result = getattr(self.contract_instance, method)(*args)
        return result