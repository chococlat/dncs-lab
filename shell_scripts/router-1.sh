export DEBIAN_FRONTEND=noninteractive


sudo sysctl -w net.ipv4.ip_forward=1
sudo ip addr add 192.168.255.1/30 dev enp0s9
sudo ip link set dev enp0s9 up
sudo ip link add link enp0s8 name enp0s8.1 type vlan id 1
sudo ip link add link enp0s8 name enp0s8.2 type vlan id 2
sudo ip addr add 192.168.0.1/23 dev enp0s8.1
sudo ip addr add 192.168.64.1/24 dev enp0s8.2
sudo ip link set dev enp0s8 up
sudo ip route add 192.168.128.0/23 via 192.168.255.2
