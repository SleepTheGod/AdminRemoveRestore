#!/bin/bash

echo -e "Choose an option:"
echo -e "1: Add all users to the sudo group"
echo -e "2: Remove all users from the sudo group"
read -p "Enter your choice (1 or 2): " choice

if [[ "$choice" == "1" ]]; then
    echo -e "CIO NIGHTMARE: Adding Users to Admin Status"
    for user in $(cut -f1 -d: /etc/passwd); do
        if id "$user" &>/dev/null; then
            if groups "$user" | grep -q "\bsudo\b"; then
                echo "$user is already an admin."
            else
                sudo usermod -aG sudo "$user" && echo "Added $user to the sudo group."
            fi
        else
            echo "User $user does not exist."
        fi
    done
elif [[ "$choice" == "2" ]]; then
    echo -e "Reverting Users from Admin Status"
    for user in $(cut -f1 -d: /etc/passwd); do
        if id "$user" &>/dev/null; then
            if groups "$user" | grep -q "\bsudo\b"; then
                sudo deluser "$user" sudo && echo "Removed $user from the sudo group."
            else
                echo "$user is not an admin."
            fi
        else
            echo "User $user does not exist."
        fi
    done
else
    echo "Invalid choice. Please run the script again and choose 1 or 2."
fi
