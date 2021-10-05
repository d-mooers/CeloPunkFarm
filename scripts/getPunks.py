from brownie import (
    accounts,
    history,
    network,
    SmartContract
)
import time
network.gas_limit(8000000)

CPUNKS = "0x9f46B8290A6D41B28dA037aDE0C3eBe24a5D1160"
ACCOUNT_NAME = 'dev-1'

def main():
    admin = accounts.load(ACCOUNT_NAME)
    punks = SmartContract.at(CPUNKS)
    numPunks = 100
    isPaused = punks.paused()
    while isPaused:
        print("I sleep for 6 seconds")
        time.sleep(6)
        isPaused = punks.paused()

    punks.mint(admin, numPunks, {"from": admin, "value": 2000000000000000000 * numPunks})