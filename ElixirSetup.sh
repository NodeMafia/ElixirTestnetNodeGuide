#!/bin/bash

# Node Mafia ASCII Art
echo "
     __             _                        __  _        
  /\ \ \  ___    __| |  ___   /\/\    __ _  / _|(_)  __ _ 
 /  \/ / / _ \  / _\` | / _ \ /    \  / _\` || |_ | | / _\` |
/ /\  / | (_) || (_| ||  __// /\/\ \| (_| ||  _|| || (_| |
\_\ \/   \___/  \__,_| \___|\/    \/ \__,_||_|  |_| \__,_|
                                                          
EN Telegram: soon..
RU Telegram: https://t.me/SixThoughtsLines
GitHub: https://github.com/NodeMafia
"

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Installing Docker..."
    # Install Docker (Ubuntu/Debian)
    sudo apt-get update
    sudo apt-get install -y docker.io
    sudo systemctl start docker
    sudo systemctl enable docker
    echo "Docker installed successfully."
else
    echo "Docker: Yes"
fi

# Create the directory and navigate into it
mkdir -p ElixirNode && cd ElixirNode || exit

# Prompt the user to input variables
read -p "Enter your server IP (<Your_server_IP>): " server_ip
read -p "Enter the name of your node (<MAKE_NAME_NODE>): " node_name
read -p "Enter your wallet address (<NEW_WALLET_ADDRESS>): " wallet_address
read -p "Enter your wallet private key (<NEW_WALLET_PRIVATE_KEY>): " private_key

# Create the validator.env file with the user's inputs
cat <<EOF > validator.env
ENV=testnet-3

STRATEGY_EXECUTOR_IP_ADDRESS=$server_ip
STRATEGY_EXECUTOR_DISPLAY_NAME=$node_name
STRATEGY_EXECUTOR_BENEFICIARY=$wallet_address
SIGNER_PRIVATE_KEY=$private_key
EOF

# Install the Elixir node image
echo "Installing the Elixir node image..."
docker pull elixirprotocol/validator:v3 --platform linux/amd64

# Start the node
echo "Starting the node..."
docker run --env-file ./validator.env --platform linux/amd64 -p 17690:17690 elixirprotocol/validator:v3