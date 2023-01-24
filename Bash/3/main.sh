#!/bin/bash
source bash_module.sh

check_root_or_sudo
change_ssh_port $1
disable_root_login
update_firewall_selinux
add_group
add_user $2 $3
create_reports
update_system
enable_epel
install_fail2ban
add_backup_cronjob
add_manager
sync_reports