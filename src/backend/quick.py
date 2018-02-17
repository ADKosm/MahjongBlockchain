import json
import web3

from web3 import Web3, HTTPProvider, TestRPCProvider
from solc import compile_source
from web3.contract import ConciseContract

import time

print("Wait for 5 sec...")

# time.sleep(3)

print("GO!")

# Solidity source code
contract_source_code = '''
pragma solidity ^0.4.0;

contract Greeter {
    string public greeting;
    string public index;

    function Greeter() {
        greeting = 'Hello';
        index = 'B-tree';
    }

    function setGreeting(string _greeting) public {
        greeting = _greeting;
    }
    
    function setIndex(string _index) public {
        index = _index;
    }

    function greet() constant returns (string) {
        return greeting;
    }
    
    function index() constant returns (string) {
        return index;
    }
}
'''

compiled_sol = compile_source(contract_source_code) # Compiled source code
contract_interface = compiled_sol['<stdin>:Greeter']

# web3.py instance
w3 = Web3(HTTPProvider('http://localhost:8545'))

# Instantiate and deploy contract
contract = w3.eth.contract(abi=contract_interface['abi'], bytecode=contract_interface['bin'])

# Get transaction hash from deployed contract
tx_hash = contract.deploy(transaction={'from': w3.eth.accounts[0], 'gas': 4100000})

time.sleep(3)
# print("tx_hash: {}".format(tx_hash))

# Get tx receipt to get contract address
tx_receipt = w3.eth.getTransactionReceipt(tx_hash)

# print(tx_receipt)
contract_address = tx_receipt['contractAddress']

# Contract instance in concise mode
contract_instance = w3.eth.contract(contract_interface['abi'], contract_address, ContractFactoryClass=ConciseContract)

# Getters + Setters for web3.eth.contract object
print('Contract value: {}'.format(contract_instance.greet()))
greeting_hash = contract_instance.setGreeting('Nihao', transact={'from': w3.eth.accounts[0]})
index_hash = contract_instance.setIndex('Hash-Map', transact={'from': w3.eth.accounts[0]})
print('Setting value to: Nihao and index to: Hash-Map')

time.sleep(3)

# print(w3.eth.getTransactionReceipt(greeting_hash))

startBlock = w3.eth.blockNumber
print("Block number: ", startBlock)

get = lambda block, pos: w3.toText(w3.eth.getStorageAt(contract_address, pos, block))

for i in range(startBlock, -1, -1):
    greeting, index = get(i, 0), get(i, 1)
    if len(greeting) == 1 and ord(greeting) == 0:
        break
    print("Greet and index: {}({}), {}".format(greeting.strip(), len(greeting), index.strip()))


print('Contract value: {}'.format(contract_instance.greet()))