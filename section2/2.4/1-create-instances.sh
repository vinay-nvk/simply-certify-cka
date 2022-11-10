#!/bin/bash
#!/bin/bash

REGION="us-west4"
ZONE="us-west4-b"
PROJECT_ID=$(gcloud config get-value project)
MACHINE_TYPE="e2-small"
SUBNET="kubeadm-nodes-subnet"
NODE_SUBNET_RANGE="10.240.0.0/24"
IMAGE_OS="projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20221015"

#Create VPC Network and subnet range for nodes
gcloud compute networks create kubeadm-network --subnet-mode custom
gcloud compute networks subnets create ${SUBNET} --network kubeadm-network --range ${NODE_SUBNET_RANGE} --region  ${REGION} 
#--enable-private-ip-google-access


INSTANCE_NAME="master-1"
NETWORK_IP="10.240.0.200"

gcloud  compute --project=${PROJECT_ID} instances create ${INSTANCE_NAME} --zone ${ZONE} \
--machine-type=${MACHINE_TYPE} --subnet=${SUBNET} \
--can-ip-forward \
--tags=${INSTANCE_NAME} \
--image=${IMAGE_OS} \
--private-network-ip ${NETWORK_IP} \
--boot-disk-size=10GB \
--boot-disk-type=pd-standard \
--boot-disk-device-name=${INSTANCE_NAME}  \
--preemptible



INSTANCE_NAME="worker-1"
NETWORK_IP="10.240.0.205"

gcloud  compute --project=${PROJECT_ID} instances create ${INSTANCE_NAME} --zone ${ZONE} \
--machine-type=${MACHINE_TYPE} --subnet=${SUBNET} \
--can-ip-forward \
--tags=${INSTANCE_NAME} \
--image=${IMAGE_OS} \
--private-network-ip ${NETWORK_IP} \
--boot-disk-size=10GB \
--boot-disk-type=pd-standard \
--boot-disk-device-name=${INSTANCE_NAME}  \
--preemptible


INSTANCE_NAME="worker-2"
NETWORK_IP="10.240.0.206"

gcloud  compute --project=${PROJECT_ID} instances create ${INSTANCE_NAME} --zone ${ZONE} \
--machine-type=${MACHINE_TYPE} --subnet=${SUBNET} \
--can-ip-forward \
--tags=${INSTANCE_NAME} \
--image=${IMAGE_OS} \
--private-network-ip ${NETWORK_IP} \
--boot-disk-size=10GB \
--boot-disk-type=pd-standard \
--boot-disk-device-name=${INSTANCE_NAME}  \
--preemptible




gcloud compute firewall-rules create kubeadm-allow-nodeprts --allow tcp:22,tcp:6443,icmp --network kubeadm-network --source-ranges 0.0.0.0/0

#gcloud compute instances list
#gcloud compute ssh ${INSTANCE_NAME}