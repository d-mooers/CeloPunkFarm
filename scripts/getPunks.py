from brownie import (
    accounts,
    history,
    network,
    CeloApes
)
import time
network.gas_limit(8000000)

CPUNKS = "0x1eCD77075F7504bA849d47DCe4cdC9695f1FE942"
ACCOUNT_NAME = 'kyle_personal'

def main():
    admin = accounts.load(ACCOUNT_NAME)
    punks = CeloApes.at(CPUNKS)
    numPunks = 69
    isPaused = punks.paused()
    while isPaused:
        time.sleep(1)
        isPaused = punks.paused()

    punks.mint(admin, numPunks, {"from": admin, "value": 3000000000000000000 * numPunks})