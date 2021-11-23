from brownie import accounts, config, SimpleStorage, network


def deploy_simple_storage():
    # brownie accounts new kovanTestNet
    account = get_account()
    #account = accounts.load("kovanTestNet")
    #account = accounts[0]
    print(account)
    simple_storage = SimpleStorage.deploy({"from": account})
    print(simple_storage)
    stored_value = simple_storage.retrieve()
    print(stored_value)
    transaction = simple_storage.store(15, {"from": account})
    transaction.wait(1)
    updated_stored_value = simple_storage.retrieve()
    print(updated_stored_value)


def get_account():
    if network.show_active() == "development":
        return accounts[0]
    else:
        return accounts.load("kovanTestNet")


def main():
    deploy_simple_storage()
