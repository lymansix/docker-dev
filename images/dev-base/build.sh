#!/usr/bin/env bash

# If one command exits with an error, stop the script immediately.
set -eo pipefail

# Print every line executed to the terminal.
set -x

apt-install() {
	sudo apt-get install --no-install-recommends -y "$@"
}

sudo apt-get update

# Super essential tools
apt-install tree curl ca-certificates

# See readme for how to get the clipboard working.
apt-install xclip

# To cryptographically sign git commits
apt-install gpg gpg-agent

# System info. Nethogs has a bug on trusty so just going to use iftop.
apt-install htop iotop iftop

# For dig, etc. On ubuntu focal, tzdata is also getting installed, so gotta
# work around that.
export DEBIAN_FRONTEND=noninteractive
apt-install net-tools

# echo 'Etc/UTC' | sudo tee /etc/timezone
apt-install dnsutils

# Needed for netstat, etc.
apt-install net-tools

# cheap reverse proxy
apt-install socat

# Packet sniffer for debugging.
apt-install tcpflow tcpdump

# Install bash tab completion.
apt-install bash-completion

# ssh
apt-install openssh-client

# ssh
apt-install openssh-server
sudo mkdir -p /var/run/sshd
sudo sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo sed -i 's@#PubkeyAuthentication yes@PubkeyAuthentication yes@' /etc/ssh/sshd_config
sudo sed -i 's@#AuthorizedKeysFile	.ssh/authorized_keys .ssh/authorized_keys2@AuthorizedKeysFile	.ssh/authorized_keys@' /etc/ssh/sshd_config
sudo echo "AllowagentForwarding yes" >> /etc/ssh/sshd_config
mkdir -p /home/lymansix/.ssh
chmod 700 /home/lymansix/.ssh
chown -R lymansix:lymansix /home/lymansix/.ssh

# tailscale
curl -fsSL https://tailscale.com/install.sh | sh

# pager better than less...
apt-install less

# ping servers
apt-install inetutils-ping

# for figuring out routing issues in the network
apt-install inetutils-traceroute

# replacement for ifconfig
apt-install iproute2

# used all the time
apt-install -y zip unzip

# magically detects file type without extension
apt-install file

# Expose local servers to the internet. Useful for testing webhooks, oauth,
# etc.
curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null
echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list
sudo apt-get update
sudo apt-get install -y --no-install-recommends ngrok

# Install git
apt-install git

# install lf with the `migrate import --above` feature
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash
sudo apt-get update
apt-install git-lfs

# subcommand which opens the branch you're checked out on github.
git clone --depth 1 https://github.com/paulirish/git-open /tmp/git-open
sudo cp /tmp/git-open/git-open /usr/local/bin
rm -rf /tmp/git-open

# Required for so many languages this will simply be included by default.
apt-install build-essential pkgconf

# Add timestamp to history.
echo 'export HISTTIMEFORMAT="%d/%m/%y %T "' >> ~/.bashrc

# Alias for tree view of commit history.
sudo git config --system alias.tree "log --all --graph --decorate=short --color --format=format:'%C(bold blue)%h%C(reset) %C(auto)%d%C(reset)\n         %C(blink yellow)[%cr]%C(reset)  %x09%C(white)%an: %s %C(reset)'"

# silence new message from git
sudo git config --system pull.rebase true

# set the hooks path to be global instead of local to a project
sudo git config --system core.hooksPath '~/.config/git/hooks'
mkdir -p ~/.config/git/hooks

# install zsh
apt-install zsh

# plugin system for zsh
curl -L -o- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh -

# theme for zsh
curl -L https://raw.githubusercontent.com/sbugzu/gruvbox-zsh/master/gruvbox.zsh-theme > ~/.oh-my-zsh/custom/themes/gruvbox.zsh-theme

cp /tmp/zshrc /home/lymansix/.zshrc
sudo rm /tmp/zshrc

# 设置时区为中国上海
sudo apt-get install -y tzdata
sudo ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
echo "Asia/Shanghai" | sudo tee /etc/timezone
sudo dpkg-reconfigure -f noninteractive tzdata

# cache is useless to keep
sudo apt-get autoremove -y
sudo apt-get clean
sudo rm -rf /var/lib/apt/lists/*

