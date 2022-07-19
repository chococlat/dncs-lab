# DNCS-LAB

This repository contains the Vagrant files required to run the virtual lab environment used in the DNCS course.
```


        +-----------------------------------------------------+
        |                                                     |
        |                                                     |eth0
        +--+--+                +------------+             +------------+
        |     |                |            |             |            |
        |     |            eth0|            |eth2     eth2|            |
        |     +----------------+  router-1  +-------------+  router-2  |
        |     |                |            |             |            |
        |     |                |            |             |            |
        |  M  |                +------------+             +------------+
        |  A  |                      |eth1                       |eth1
        |  N  |                      |                           |
        |  A  |                      |                           |
        |  G  |                      |                     +-----+----+
        |  E  |                      |eth1                 |          |
        |  M  |            +-------------------+           |          |
        |  E  |        eth0|                   |           |  host-c  |
        |  N  +------------+      SWITCH       |           |          |
        |  T  |            |                   |           |          |
        |     |            +-------------------+           +----------+
        |  V  |               |eth2         |eth3                |eth0
        |  A  |               |             |                    |
        |  G  |               |             |                    |
        |  R  |               |eth1         |eth1                |
        |  A  |        +----------+     +----------+             |
        |  N  |        |          |     |          |             |
        |  T  |    eth0|          |     |          |             |
        |     +--------+  host-a  |     |  host-b  |             |
        |     |        |          |     |          |             |
        |     |        |          |     |          |             |
        ++-+--+        +----------+     +----------+             |
        | |                              |eth0                   |
        | |                              |                       |
        | +------------------------------+                       |
        |                                                        |
        |                                                        |
        +--------------------------------------------------------+



```

# Requirements
 - Python 3
 - 10GB disk storage
 - 2GB free RAM
 - Virtualbox
 - Vagrant (https://www.vagrantup.com)
 - Internet

# How-to
 - Install Virtualbox and Vagrant
 - Clone this repository
`git clone https://github.com/fabrizio-granelli/dncs-lab`
 - You should be able to launch the lab from within the cloned repo folder.
```
cd dncs-lab
[~/dncs-lab] vagrant up
```
Once you launch the vagrant script, it may take a while for the entire topology to become available.
 - Verify the status of the 4 VMs
 ```
 [dncs-lab]$ vagrant status                                                                                                                                                                
Current machine states:

router                    running (virtualbox)
switch                    running (virtualbox)
host-a                    running (virtualbox)
host-b                    running (virtualbox)
```
- Once all the VMs are running verify you can log into all of them:
`vagrant ssh router`
`vagrant ssh switch`
`vagrant ssh host-a`
`vagrant ssh host-b`
`vagrant ssh host-c`

# Assignment
This section describes the assignment, its requirements and the tasks the student has to complete.
The assignment consists in a simple piece of design work that students have to carry out to satisfy the requirements described below.
The assignment deliverable consists of a Github repository containing:
- the code necessary for the infrastructure to be replicated and instantiated
- an updated README.md file where design decisions and experimental results are illustrated
- an updated answers.yml file containing the details of your project

## Design Requirements
- Hosts 1-a and 1-b are in two subnets (*Hosts-A* and *Hosts-B*) that must be able to scale up to respectively 509 and 188 usable addresses
- Host 2-c is in a subnet (*Hub*) that needs to accommodate up to 404 usable addresses
- Host 2-c must run a docker image (dustnic82/nginx-test) which implements a web-server that must be reachable from Host-1-a and Host-1-b
- No dynamic routing can be used
- Routes must be as generic as possible
- The lab setup must be portable and executed just by launching the `vagrant up` command

## Tasks
- Fork the Github repository: https://github.com/fabrizio-granelli/dncs-lab
- Clone the repository
- Run the initiator script (dncs-init). The script generates a custom `answers.yml` file and updates the Readme.md file with specific details automatically generated by the script itself.
  This can be done just once in case the work is being carried out by a group of (<=2) engineers, using the name of the 'squad lead'. 
- Implement the design by integrating the necessary commands into the VM startup scripts (create more if necessary)
- Modify the Vagrantfile (if necessary)
- Document the design by expanding this readme file
- Fill the `answers.yml` file where required (make sure that is committed and pushed to your repository)
- Commit the changes and push to your own repository
- Notify the examiner (fabrizio.granelli@unitn.it) that work is complete specifying the Github repository, First Name, Last Name and Matriculation number. This needs to happen at least 7 days prior an exam registration date.

# Notes and References
- https://rogerdudler.github.io/git-guide/
- http://therandomsecurityguy.com/openvswitch-cheat-sheet/
- https://www.cyberciti.biz/faq/howto-linux-configuring-default-route-with-ipcommand/
- https://www.vagrantup.com/intro/getting-started/


# Design

The following values for the number of addresses were given:
- *Hosts-A* : 509 usable addresses
- *Hosts-B* : 188 usable addresses
- *Hub* : 404 usable addresses

To achieve that the following choices have been made:

**Hosts-A** [Host-a -> Router-1]: Required 509 ---  2^(32-23)-2 = 512-2 = 510
- Subnet mask: 11111111.11111111.11111110.00000000          ( 255.255.254.0 )
- Chosen IP:      11000000.10101000.0000000|0.00000000           ( 192.168.0.0/23 )
- Range usable addresses: [192.168.0.1 ->  192.168.1.254]

**Hosts-B** [Host-b -> Router-1]: Required 188 ---  2^(32-24)-2 = 256-2 = 254
- Subnet mask: 11111111.11111111.11111111.00000000  ( 255.255.255.0 )
- Chosen IP: 11000000.10101000.01000000.|00000000  ( 192.168.64.0/24 )
- Range usable addresses: [192.168.64.1 -> 192.168.64.254]

**Hub** [Host-c -> Router 2]: Required 404 ---  2^(32-23)-2 = 512-2 = 510
- Subnet mask: 11111111.11111111.11111110.00000000  ( 255.255.254.0 )
- Chosen IP: 11000000.10101000.1000000|0.00000000  ( 192.168.128.0/23 )
- Range usable addresses: [192.168.128.1 -> 192.168.129.254]

Additional subnet for the 2 routers:

**R-Subnet** [Router-1 -> Router-2]: Required 2 ____ 2^(32-30)-2=4-2=2:
- Subnet mask: 11111111.11111111.11111111.11111100  (255.255.255.252)
- Chosen IP:  11000000.10101000.11111111.000000|00  (192.168.255.0/30)
- Range usable addresses: [192.168.255.1 -> 192.168.255.2]

After logging in ssh in each virtual machine, the `$ dmesg | grep -i  eth` command has been used to match the eth-x namespace with the enp0s-x one in Vagrant. The relevant part of the output was:


- **router-1** and **router-2**:
enp0s3: renamed from eth0
enp0s8: renamed from eth1
enp0s9: renamed from eth2
- **host-a**, **host-b** and **host-c**:
enp0s3: renamed from eth0
enp0s8: renamed from eth1
- **switch**:
enp0s3: renamed from eth0
enp0s8: renamed from eth1
enp0s9: renamed from eth2
enp0s10: renamed from eth3

In the following table there are the addresses of all the nodes that we are using and the relative interfaces.

| VM| Port/Interface|   IP address |  Subnet |
|----|----|---------------|-----|
| host-a|enp0s8 (eth-1)|  192.168.0.1|  Hosts-A |
| router-1|enp0s8.1 (eth-1)|  192.168.0.2|  Hosts-A |
| host-b|enp0s8 (eth-1)|  192.168.64.1|  Hosts-B |
| router-1|enp0s8.2 (eth-1)|  192.168.64.2|  Hosts-B |
| host-c|enp0s8 (eth-1)|  192.168.128.1|  Hub |
| router-2|enp0s8 (eth1)|  192.168.128.2|  Hub |
| router-1|enp0s9 (eth-2)|  192.168.255.1|  R-Subnet |
| router-2|enp0s9 (eth-2)|  192.168.255.2|  R-Subnet |


