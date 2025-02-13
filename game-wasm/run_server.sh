#!/bin/bash

# Function to check if a command exists
check_command() {
    if ! command -v "$1" &> /dev/null; then
        echo "Error: $1 is not installed"
        exit 1
    fi
}

# Function to kill process on port 8000 if it exists
kill_existing_server() {
    local pid=$(lsof -ti:8000)
    if [ ! -z "$pid" ]; then
        echo "Found existing server on port 8000 (PID: $pid). Killing process..."
        kill -9 "$pid"
        sleep 1  # Give the system time to free up the port
    fi
}

# Function to build the WebAssembly package
build_wasm() {
    echo "Building WebAssembly package..."
    if ! wasm-pack build --target web; then
        echo "Error: Failed to build WebAssembly package"
        return 1
    fi
    echo "Build complete! Refresh your browser to see changes."
    return 0
}

# Function to handle keypress
handle_keypress() {
    read -r -n1 -s key
    case "$key" in
        r|R)
            echo "Rebuilding WASM..."
            build_wasm
            ;;
        q|Q)
            echo "Quitting..."
            exit 0
            ;;
    esac
}

# Check for required commands
check_command "wasm-pack"
check_command "python3"

# Initial build
build_wasm || exit 1

# Kill any existing server on port 8000
kill_existing_server

# Start the Python server
echo "Starting Python server..."
python3 -m http.server 8000 &

# Save the server's PID
SERVER_PID=$!

# Function to cleanup on script exit
cleanup() {
    echo "Stopping server..."
    kill -9 $SERVER_PID 2>/dev/null
}

# Set up trap for cleanup
trap cleanup EXIT

echo "Server running at http://localhost:8000"
echo "Press 'r' to rebuild WASM package"
echo "Press 'q' to quit"

# Wait for and handle keypresses
while true; do
    handle_keypress
done
