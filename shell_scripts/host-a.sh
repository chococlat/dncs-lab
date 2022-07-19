export DEBIAN_FRONTEND=noninteractive


sudo ip addr add 192.168.0.2/23 dev enp0s8
sudo ip link set dev enp0s8 up
sudo ip route add 192.168.255.0/30 via 192.168.0.1
sudo ip route add 192.168.0.0/16 via 192.168.0.1
