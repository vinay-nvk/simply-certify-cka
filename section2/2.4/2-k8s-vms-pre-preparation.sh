############# PREPAIR ALL HOSTS INCLUDING CONTROL PLANE AND NODES TO INSTALL KUBEADM  ############# 
# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/

sudo apt-get update

#1. Disable linux swap and remove any existing swap partitions
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab


#2. Enable required Kernel Modules to  make sure CNI Pugins and Continer Runtime to work properly 
# https://kubernetes.io/docs/setup/production-environment/container-runtimes/

cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/containerd.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system


#3. Install a Container Runtime ( Containerd )
#Link: https://kubernetes.io/docs/setup/production-environment/container-runtimes/

echo "Y" | sudo apt install containerd

#Generate to containerd configuration file 
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml

#containerd defualt cgroup driver is cgroufs, I am changing that to systemd for learning purpose
#Find the line SystemdCgroup = false and change the value to true
sudo sed -i -e '/SystemdCgroup =/ s/= .*/= true/'  /etc/containerd/config.toml

sudo systemctl restart containerd
sudo systemctl enable containerd

##### Additional Commands if required.........
#sudo systemctl daemon-reload
#ps -ef | grep containerd
