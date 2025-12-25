#!/bin/sh

set -e

# Process environment variables and update config.json
CONFIG_FILE="./conf/config.json"
TEMP_CONFIG="/tmp/config.json"

# Copy the original config to temp location
cp "$CONFIG_FILE" "$TEMP_CONFIG"

# Update username if USERNAME environment variable is set
if [ -n "$USERNAME" ]; then
    echo "Setting username to: $USERNAME"
    sed -i "s/\"uname1\"/\"$USERNAME\"/g" "$TEMP_CONFIG"
fi

# Update password if PASSWORD environment variable is set
if [ -n "$PASSWORD" ]; then
    echo "Setting password (hidden)"
    sed -i "s/\"pwd1\"/\"$PASSWORD\"/g" "$TEMP_CONFIG"
fi

# Update protocol if PROTOCOL environment variable is set
if [ -n "$PROTOCOL" ]; then
    echo "Setting protocol to: $PROTOCOL"
    sed -i "s/\"UDP\"/\"$PROTOCOL\"/g" "$TEMP_CONFIG"
fi

mita run &
sleep 2

mita apply config "$TEMP_CONFIG"
mita start
mita describe config

wait -n
