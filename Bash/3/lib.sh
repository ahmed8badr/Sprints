#!/bin/bash

# check if the user running the script is either root or has sudoer privileges
function check_root_or_sudo() {
if [[ $EUID -ne 0 ]] && [[ $(id -u) -ne 0 ]]; then
    echo "This script must be run as root or with sudo privileges"
    exit 1
fi
}

# change the SSH default port
function change_ssh_port() {
if [[ -z $1 ]]; then
    echo "Please provide new SSH port number as first argument"
    exit 1
fi
new_port=$1
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

# update firewall and SELinux to the new SSH port
function update_firewall_selinux() {
firewall-cmd --add-port=$new_port/tcp --permanent
firewall-cmd --reload
semanage port -a -t ssh_port_t -p tcp $new_port
}

# add a new group (Audit) with id 20000
function add_group() {
groupadd -g 20000 Audit
}

# add a new user
function add_user() {
    if [[ -z $1 ]]; then
        echo "Please provide new username as second argument"
        exit 1
    fi
    if [[ -z $2 ]]; then
        echo "Please provide new password as third argument"
        exit 1
    fi
    username=$1
    password=$2
    useradd -m -g Audit -s /bin/bash $username
    echo $username:$password | chpasswd
}


# create reports for the whole year
function create_reports() {
if [ ! -d /home/$username/reports ]; then
    mkdir /home/$username/reports
fi
for month in {01..12}; do
    for day in {01..31}; do
        touch /home/$username/reports/2023-"$month"-"$day".xls
    done
done
chown -R $username:Audit /home/$username/reports
chmod -R 750 /home/$username/reports
}

# update and upgrade your system
function update_system() {
apt-get update
apt-get upgrade -y
}

# enable EPEL repository
function enable_epel() {
    yum install -y epel-release
}

# install fail2ban and make sure it's enabled at boot time
function install_fail2ban() {
    yum install -y fail2ban
    systemctl enable fail2ban
    systemctl start fail2ban
}

# add chron job
function add_backup_cronjob() {
    (crontab -l 2>/dev/null; echo "01 01 * * 1-5 tar -zcvf /root/backups/reports-$(date +\%U)-$(date +\%u).tar.gz /home/$username/reports/") | crontab -
}

# add a new user (manager) with uid 30000
function add_manager() {
    useradd -u 30000 -m manager
}

#  sync the reports daily
function sync_reports() {
    (crontab -l 2>/dev/null; echo "02 02 * * 1-5 rsync -av /home/$username/reports/ /home/manager/audit/reports/") | crontab -
}