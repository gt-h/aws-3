#!/usr/bin/env bash

echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward
sudo sed -i  's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf

sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sudo iptables-save > /etc/iptables.up.rules

echo "pre-up iptables-restore < /etc/iptables.up.rules" | sudo tee /etc/networks/interfaces
