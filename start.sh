#!/bin/bash

# Color codes for better readability
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Starting go-mirror-bot services...${NC}"

# Make aria.sh executable if it's not already
if [ ! -x "aria.sh" ]; then
    echo -e "${YELLOW}Making aria.sh executable...${NC}"
    chmod +x aria.sh
fi

# Function to clean up processes when the script exits
cleanup() {
    echo -e "\n${YELLOW}Stopping services...${NC}"
    
    # Kill bot process
    if [ ! -z "$BOT_PID" ]; then
        echo -e "${YELLOW}Stopping go-mirror-bot (PID: $BOT_PID)...${NC}"
        kill $BOT_PID
    fi
    
    # Kill aria2c process 
    ARIA_PID=$(pgrep -f "aria2c --enable-rpc")
    if [ ! -z "$ARIA_PID" ]; then
        echo -e "${YELLOW}Stopping aria2c (PID: $ARIA_PID)...${NC}"
        kill $ARIA_PID
    fi
    
    echo -e "${GREEN}All services stopped.${NC}"
    exit 0
}

# Register the cleanup function for when script receives SIGINT, SIGTERM
trap cleanup SIGINT SIGTERM

# Start aria2c daemon in the background
echo -e "${YELLOW}Starting aria2c daemon...${NC}"
./aria.sh &
ARIA_PID=$!

# Wait for aria2c to fully start
echo -e "${YELLOW}Waiting for aria2c to initialize (3 seconds)...${NC}"
sleep 3

# Check if aria2c is running
if ! pgrep -f "aria2c --enable-rpc" > /dev/null; then
    echo -e "${RED}Failed to start aria2c. Exiting.${NC}"
    exit 1
fi

echo -e "${GREEN}aria2c daemon started successfully.${NC}"

# Start the go-mirror-bot
echo -e "${YELLOW}Starting go-mirror-bot...${NC}"
./go-mirror-bot &
BOT_PID=$!

# Check if bot started successfully (after a short delay)
sleep 2
if ! ps -p $BOT_PID > /dev/null; then
    echo -e "${RED}Failed to start go-mirror-bot. Exiting.${NC}"
    cleanup
    exit 1
fi

echo -e "${GREEN}All services started!${NC}"
echo -e "${GREEN}aria2c daemon (PID: $ARIA_PID)${NC}"
echo -e "${GREEN}go-mirror-bot (PID: $BOT_PID)${NC}"
echo -e "${YELLOW}Press Ctrl+C to stop all services${NC}"

# Wait for both processes
wait 
