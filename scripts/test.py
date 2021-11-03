from brownie import (
    accounts,
    network,
    SmartContract
)
import time
network.gas_limit(8000000)

ACCOUNT_NAME = 'dev-1'

def main():
    admin = accounts.load('dahlia_alice')
    punks = SmartContract.deploy("punk", "punk", "punk", {'from': admin})
    numPunks = 1
    isPaused = punks.paused()
    while isPaused:
        print("I sleep for 6 seconds")
        time.sleep(6)
        isPaused = punks.paused()

    punks.mint(admin, numPunks, {"from": admin, "value": 2000000000000000000 * numPunks})