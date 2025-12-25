#!/bin/sh

set -e

# Process environment variables and update config.json
CONFIG_FILE="./conf/config.json"
TEMP_CONFIG="/tmp/config.json"

# Copy the original config to temp location
cp "$CONFIG_FILE" "$TEMP_CONFIG"

# Function to escape special characters for sed
escape_for_sed() {
    printf '%s\n' "$1" | sed -e 's/[\/&]/\\&/g'
}

# Update username if USERNAME environment variable is set
if [ -n "$USERNAME" ]; then
    echo "Setting username to: $USERNAME"
    ESCAPED_USERNAME=$(escape_for_sed "$USERNAME")
    sed -i "s/\"name\": *\"uname1\"/\"name\": \"$ESCAPED_USERNAME\"/g" "$TEMP_CONFIG"
fi

# Update password if PASSWORD environment variable is set
if [ -n "$PASSWORD" ]; then
    echo "Setting password (hidden)"
    ESCAPED_PASSWORD=$(escape_for_sed "$PASSWORD")
    sed -i "s/\"password\": *\"pwd1\"/\"password\": \"$ESCAPED_PASSWORD\"/g" "$TEMP_CONFIG"
fi

# Update protocol if PROTOCOL environment variable is set
if [ -n "$PROTOCOL" ]; then
    # Validate protocol value
    if [ "$PROTOCOL" != "UDP" ] && [ "$PROTOCOL" != "TCP" ]; then
        echo "Error: PROTOCOL must be either 'UDP' or 'TCP', got '$PROTOCOL'"
        exit 1
    fi
    echo "Setting protocol to: $PROTOCOL"
    sed -i "s/\"protocol\": *\"UDP\"/\"protocol\": \"$PROTOCOL\"/g" "$TEMP_CONFIG"
fi

mita run &
sleep 2

mita apply config "$TEMP_CONFIG"
mita start
mita describe config

wait -n
