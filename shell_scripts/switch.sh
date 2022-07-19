export DEBIAN_FRONTEND=noninteractive
sudo apt-get update
sudo apt-get install -y tcpdump
sudo apt-get install -y openvswitch-common openvswitch-switch apt-transport-https ca-certificates curl software-properties-common


# Startup commands for switch go here

export DEBIAN_FRONTEND=noninteractive
sudo apt-get update
sudo apt-get install -y tcpdump
sudo apt-get install -y openvswitch-common openvswitch-switch apt-transport-https ca-certificates curl software-properties-common
sudo ovs-vsctl add-br switch
sudo ovs-vsctl add-port switch enp0s8
sudo ovs-vsctl add-port switch enp0s9 tag="1"
sudo ovs-vsctl add-port switch enp0s10 tag="2"
sudo ip link set dev enp0s8 up
sudo ip link set dev enp0s9 up
sudo ip link set dev enp0s10 up
