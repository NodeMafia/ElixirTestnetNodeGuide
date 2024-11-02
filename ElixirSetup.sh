#!/bin/bash

# Node Mafia ASCII Art
echo "
     __             _                        __  _        
  /\ \ \  ___    __| |  ___   /\/\    __ _  / _|(_)  __ _ 
 /  \/ / / _ \  / _\` | / _ \ /    \  / _\` || |_ | | / _\` |
/ /\  / | (_) || (_| ||  __// /\/\ \| (_| ||  _|| || (_| |
\_\ \/   \___/  \__,_| \___|\/    \/ \__,_||_|  |_| \__,_|

EN Telegram: soon..
RU Telegram: https://t.me/nodemafia
GitHub: https://github.com/NodeMafia
Medium: https://medium.com/@nodemafia
Teletype: https://teletype.in/@nodemafia
Twitter: https://x.com/NodeMafia
"

# Display environment structure
echo -e "\nYour environment should look like this if you haven't used the script before:"
echo "$USER"
echo "└── ElixirNode"
echo "      ├─── validator.env (for Testnet)"
echo "      └──── validator2.env (for Mainnet)"

# Menu options
echo -e "\nSelect an option:"
echo "1) First Run Testnet Node"
echo "2) Run or Update Testnet Node"
echo "3) First Run Mainnet Node"
echo "4) Run or Update Mainnet Node"
echo "5) View  Testnet Node logs"
echo "6) View  Mainnet Node logs"
read -p "Enter your choice [1-6]: " choice

# Execute actions based on choice
case $choice in
  1)
    echo "Starting first run for Testnet Node..."
    # Check if Docker is installed
    if ! command -v docker &> /dev/null; then
        echo "Docker is not installed. Installing Docker..."
        sudo apt-get update
        sudo apt-get install -y docker.io
        sudo systemctl start docker
        sudo systemctl enable docker
        echo "Docker installed successfully."
    else
        echo "Docker: Yes"
    fi

    # Check if the ElixirNode directory exists, create if not, and navigate into it
    if [ -d "ElixirNode" ]; then
        echo "Directory 'ElixirNode' already exists. Navigating into it."
    else
        echo "Directory 'ElixirNode' does not exist. Creating it."
        mkdir ElixirNode
    fi
    cd ElixirNode || exit
    echo "Now in $(pwd)"

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
    docker pull elixirprotocol/validator:testnet-3 --platform linux/amd64

    # Start the node
    echo "Starting the node..."
    docker run --env-file ./validator.env --platform linux/amd64 -p 17690:17690 elixirprotocol/validator:testnet-3
    ;;

  2)
    echo "Running or updating Testnet Node..."
    
    # Find the container ID for the specified image
    container_id=$(docker ps -q --filter "ancestor=elixirprotocol/validator:testnet-3")

    # Check if the container exists
    if [ -n "$container_id" ]; then
        echo "Found container with ID $container_id for image elixirprotocol/validator:testnet-3."
        
        # Stop the container
        docker kill "$container_id"
        echo "Container $container_id stopped."

        # Remove the container
        docker rm "$container_id"
        echo "Container $container_id removed."
    else
        echo "No running container found with image elixirprotocol/validator:testnet-3."
    fi

    # Navigate to ElixirNode directory
    cd ElixirNode

    # Install the Elixir node image
    echo "Installing the Elixir node image..."
    docker pull elixirprotocol/validator:testnet-3 --platform linux/amd64

    # Start the node
    echo "Starting the node..."
    docker run --env-file ./validator.env --platform linux/amd64 -p 17690:17690 elixirprotocol/validator:testnet-3
    ;;

  3)
    echo "Starting first run for Mainnet Node..."

    # Check if Docker is installed
    if ! command -v docker &> /dev/null; then
        echo "Docker is not installed. Installing Docker..."
        sudo apt-get update
        sudo apt-get install -y docker.io
        sudo systemctl start docker
        sudo systemctl enable docker
        echo "Docker installed successfully."
    else
        echo "Docker: Yes"
    fi

    # Check if the ElixirNode directory exists, create if not, and navigate into it
    if [ -d "ElixirNode" ]; then
        echo "Directory 'ElixirNode' already exists. Navigating into it."
    else
        echo "Directory 'ElixirNode' does not exist. Creating it."
        mkdir ElixirNode
    fi
    cd ElixirNode || exit
    echo "Now in $(pwd)"

    # Prompt the user to input variables
    read -p "Enter the name of your node (<MAKE_NAME_NODE>): " node_name
    read -p "Enter your wallet address (<NEW_WALLET_ADDRESS>): " wallet_address
    read -p "Enter your wallet private key (<NEW_WALLET_PRIVATE_KEY>): " private_key

    # Create the validator2.env file with the user's inputs
    cat <<EOF > validator2.env
ENV=prod

STRATEGY_EXECUTOR_DISPLAY_NAME=$node_name
STRATEGY_EXECUTOR_BENEFICIARY=$wallet_address
SIGNER_PRIVATE_KEY=$private_key
EOF

    # Install the Elixir node image
    echo "Installing the Elixir node image..."
    docker pull elixirprotocol/validator --platform linux/amd64

    # Start the Mainnet node
    echo "Starting the Mainnet node..."
    docker run --env-file ./validator2.env --platform linux/amd64 --name elixir2 elixirprotocol/validator
    ;;

  4)
    echo "Running or updating Mainnet Node..."

    # Find the container ID for the specified image
    container_id=$(docker ps -q --filter "ancestor=elixirprotocol/validator")

    # Check if the container exists
    if [ -n "$container_id" ]; then
        echo "Found container with ID $container_id for image elixirprotocol/validator."
        
        # Stop the container
        docker kill "$container_id"
        echo "Container $container_id stopped."

        # Remove the container
        docker rm "$container_id"
        echo "Container $container_id removed."
    else
        echo "No running container found with image elixirprotocol/validator."
    fi

    # Navigate to ElixirNode directory
    cd ElixirNode

    # Install the Elixir node image
    echo "Installing the Elixir node image..."
    docker pull elixirprotocol/validator --platform linux/amd64

    # Start the Mainnet node
    echo "Starting the Mainnet node..."
    docker run --env-file ./validator2.env --platform linux/amd64 --name elixir2 elixirprotocol/validator
    ;;
  
  5)
    echo "Logs Testnet"
    
    # Find the container ID for the specified image
    container_id=$(docker ps -q --filter "ancestor=elixirprotocol/validator:testnet-3")

    # Check if the container exists
    if [ -n "$container_id" ]; then
        echo "Found container with ID $container_id for image ancestor=elixirprotocol/validator:testnet-3."
        
        # Logs of the container
        docker logs -n 10 -f "$container_id"
        echo "Logs $container_id ."

    else
        echo "No running container found with image ancestor=elixirprotocol/validator:testnet-3."
    fi
    ;;
  6)
    echo "Logs Testnet"
    
    # Find the container ID for the specified image
    container_id=$(docker ps -q --filter "ancestor=elixirprotocol/validator")

    # Check if the container exists
    if [ -n "$container_id" ]; then
        echo "Found container with ID $container_id for image elixirprotocol/validator."
        
        # Logs of the container
        docker logs -n 10 -f "$container_id"
        echo "Logs $container_id ."

    else
        echo "No running container found with image elixirprotocol/validator."
    fi
    ;;
    
  *)
    echo "Invalid choice. Please enter a number between 1 and 4."
    ;;
esac
