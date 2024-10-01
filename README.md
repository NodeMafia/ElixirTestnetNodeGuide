# Elixir TestNet (v3.4.6*updated)

![image](https://github.com/user-attachments/assets/dc422a87-feb7-444c-a23c-e2fa23f5358c)

## Elixir — a decentralised modular network designed to provide liquidity on decentralised order book (DEX) based exchanges.
$17,600,000 investment from Arthur Hayes, Maelstrom, Amber Group, etc. Node requirements are 4CPU/8RAM/100SSD 

The platform allows us to mint us 1,000 MOCKs on the Sepolia network. MOCKs can be deallocated to a working node. The site has a line about rewards, so we can hope for bonuses to steak elxETH or other Elixir stackablecoins. There is no official information about this, but in order not to miss the chance of rewards we advise you to delegate MOCKs from the EVM wallet where you staked your funds with Elixir.

### What's required:
- Server on Linux
- 2 EVM waletts(For security, one of the wallets should never be used for anything other than running a testnet validator.) 

Before running Node, add Sepolia network to your wallet and get test SepoliETH here https://cloud.google.com/application/web3/faucet/ethereum/sepolia.

Go to https://testnet-3.elixir.xyz/, log in with your wallet and mint 1000 MOCKs. Then choose the maximum number of MOCKs in the menu below and click on APPROVE MOCK FOR STAKING. After staking, click on CUSTOM VALIDATOR below and enter the address for your newly created node wallet. Click DELEGATE.

![image](https://github.com/user-attachments/assets/29eddbdd-aa47-4087-8514-2e1539abae27)

## Node installation

All commands below can be replaced by our installer. To do this, copy this command and follow the instructions.

```
bash -i <(curl -s https://raw.githubusercontent.com/NodeMafia/ElixirTestnetNodeGuide/refs/heads/main/ElixirSetup.sh)
```


You connect to your server and test Docker. If it doesn't exist, install Docker

```
docker -version
```

Create a directory and navigate to it with the command

```
mkdir ElixirNode && cd ElixirNode
```

Before performing the following steps you will need the private key of your new wallet, the address of which we wrote in CUSTOM VALIDATOR!
Create node configuration file (we need nano)

```
nano validator.env
```

In the configuration file insert with replacement data without <>
```
ENV=testnet-3

STRATEGY_EXECUTOR_IP_ADDRESS=<Your_server_IP>
STRATEGY_EXECUTOR_DISPLAY_NAME=<MAKE_NAME_NODE>
STRATEGY_EXECUTOR_BENEFICIARY=<NEW_WALLET_ADDRESS>
SIGNER_PRIVATE_KEY=<NEW_WALLET_PRIVATE_KEY>
```
To save the configuration press CTRL+X, Y, Enter. 
Install image Elixir node.

```
docker pull elixirprotocol/validator:v3 --platform linux/amd64
```

Start the node

```
docker run --env-file ./validator.env --platform linux/amd64 -p 17690:17690 elixirprotocol/validator:v3
```

If you see NO CONFIGURATION ERRORS FOUND, then everything is successful.
Now you can see your uptime on the testnet site. 

![image](https://github.com/user-attachments/assets/8f99bc3b-f1b3-4b7b-83cc-ece407287394)

## Updating the node
```
docker ps 
```
Select the Container ID of your Elixir node 
```
docker kill Container_ID
docker rm Container_ID
docker pull elixirprotocol/validator:v3 --platform linux/amd64
cd ElixirNode
docker run --env-file ./validator.env --platform linux/amd64 -p 17690:17690 elixirprotocol/validator:v3
```
