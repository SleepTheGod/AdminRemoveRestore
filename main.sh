#!/bin/bash

echo -e "\n🔥 Crafted by Taylor Christian Newsome for System Administrators 🔥"
echo -e "\nThis script aims to showcase robust admin management capabilities.\n"
echo -e "Please select an action: "
echo -e "1: Add all users to the sudo group (Admin Privileges)"
echo -e "2: Remove all users from the sudo group (Revoke Admin Privileges)"
read -p "Enter your choice (1 or 2): " choice

# Function to check if a command succeeded and log it
log_action() {
    if [[ $? -eq 0 ]]; then
        echo -e "[SUCCESS] $1"
    else
        echo -e "[ERROR] $1" >&2
    fi
}

# Function to add all users to the sudo group
add_all_to_sudo() {
    echo -e "\n🚨 CIO NIGHTMARE: Granting Admin Privileges to All Users 🚨"
    for user in $(cut -f1 -d: /etc/passwd); do
        if id "$user" &>/dev/null; then
            if groups "$user" | grep -q "\bsudo\b"; then
                echo -e "[INFO] $user is already an admin."
            else
                sudo usermod -aG sudo "$user" && log_action "Added $user to the sudo group."
            fi
        else
            log_action "User $user does not exist."
        fi
    done
}

# Function to remove all users from the sudo group
remove_all_from_sudo() {
    echo -e "\n🔒 Reverting Admin Privileges from All Users 🔒"
    for user in $(cut -f1 -d: /etc/passwd); do
        if id "$user" &>/dev/null; then
            if groups "$user" | grep -q "\bsudo\b"; then
                sudo deluser "$user" sudo && log_action "Removed $user from the sudo group."
            else
                echo -e "[INFO] $user does not have admin privileges."
            fi
        else
            log_action "User $user does not exist."
        fi
    done
}

# Execute based on choice
if [[ "$choice" == "1" ]]; then
    add_all_to_sudo
elif [[ "$choice" == "2" ]]; then
    remove_all_from_sudo
else
    echo -e "[ERROR] Invalid choice. Please run the script again and select either 1 or 2."
fi

# Logging complete script execution
echo -e "\n✅ Script Execution Complete - Please Review Actions Logged Above ✅"
