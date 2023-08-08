#!/usr/bin/env sh
set -x
set -e

sudo ip netns add client
sudo ip netns add router
sudo ip netns add server

sudo ip link add name client-veth1 type veth peer name router-veth1
sudo ip link add name router-veth2 type veth peer name server-veth1

sudo ip link set client-veth1 netns client
sudo ip link set router-veth1 netns router
sudo ip link set router-veth2 netns router
sudo ip link set server-veth1 netns server

sudo ip netns exec client ip addr add 10.0.0.1/24 dev client-veth1
sudo ip netns exec router ip addr add 10.0.0.254/24 dev router-veth1
sudo ip netns exec router ip addr add 10.0.1.254/24 dev router-veth2
sudo ip netns exec server ip addr add 10.0.1.1/24 dev server-veth1

sudo ip netns exec client ip link set client-veth1 up
sudo ip netns exec router ip link set router-veth1 up
sudo ip netns exec router ip link set router-veth2 up
sudo ip netns exec server ip link set server-veth1 up
sudo ip netns exec client ip link set lo up
sudo ip netns exec router ip link set lo up
sudo ip netns exec server ip link set lo up

sudo ip netns exec client ip route add 0.0.0.0/0 via 10.0.0.254
sudo ip netns exec server ip route add 0.0.0.0/0 via 10.0.1.254
sudo ip netns exec router sysctl -w net.ipv4.ip_forward=1
