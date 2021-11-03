from brownie import (
    accounts,
    history,
    network,
    SmartContract
)
import time
network.gas_limit(8000000)

CPUNKS = "0x9f46B8290A6D41B28dA037aDE0C3eBe24a5D1160"
ACCOUNT_NAME = 'kyle_personal'
TO = '0x792BC1C0AeEf221F8024b2c1ae47918bd42B9b9F'

ids = [i for i in range(9607, 9611)]

def main():
    admin = accounts.load(ACCOUNT_NAME)
    punks = SmartContract.at(CPUNKS)
    for id in ids:
        punks.transferFrom(admin.address, TO, id, {'from': admin})
