#!/bin/bash

# check if user running the script has root privileges
function check_root() {
  if [ $EUID -ne 0 ]; then
    echo "This script must be run as root"
    exit 1
  fi
}

# change SSH default port
function change_ssh_port() {
  read -p "Enter new SSH port: " new_port
  sed -i "s/^Port.*/Port $new_port/" /etc/ssh/sshd_config
  systemctl restart ssh
  echo "SSH default port changed to $new_port"
}

# disable root login
function disable_root_login() {
  sed -i 's/^PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
  systemctl restart ssh
  echo "Root login disabled"
}

# add new user to the system
function add_user() {
  read -p "Enter new username: " username
  adduser $username
  read -p "Add $username to sudoers? (y/n) " choice
  if [ "$choice" == "y" ]; then
    usermod -aG sudo $username
    echo "$username has been added to sudoers"
  else
    echo "$username has been added as a regular user"
  fi
}

# add backup to crontab
function add_backup_crontab() {
  read -p "Enter backup interval in minutes: " interval
  echo "Adding backup to crontab with an interval of $interval minutes"
  (crontab -l 2>/dev/null; echo "*/$interval * * * * tar -zcvf /var/backups/home_$(date +\%Y\%m\%d_\%H\%M).tar.gz /home/") | crontab -
}

# Wait for file to exist before quitting the loop
function wait_for_file() {
  read -p "Enter file path: " file
  while [ ! -f $file ]; do
    sleep 1
  done
  echo "File $file now exists"
}

# Calling libraries 

check_root
change_ssh_port
disable_root_login
add_user
add_backup_crontab
wait_for_file