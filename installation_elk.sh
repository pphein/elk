#!/bin/bash

# environments
NAMESPACE="elasticsearch"
VALUES_FILE="values.yaml"

# create namespace
echo "checking the namespace: $NAMESPACE"
if ! kmicrok8s.kubectl get namespace "$NAMESPACE" &>/dev/null; then
    echo "Namespace '$NAMESPACE' not found, creating..."
    microk8s.kubectl create namespace "$NAMESPACE"
else
    echo "Namespace '$NAMESPACE' already existed, passing."
fi

# Add the Elastic Helm charts repo
microk8s.helm3 repo add elastic https://helm.elastic.co

# install elasticsearch
cd elasticsearch
microk8s.helm3 upgrade --install elastic elastic/elasticsearch --version 8.5.1 -f $VALUES_FILE -n $NAMESPACE

# install logstash
cd ../logstash
microk8s.helm3 upgrade --install logstash elastic/logstash --version 8.5.1 -f $VALUES_FILE -n $NAMESPACE 

# install filebeat
cd ../filebeat
microk8s.helm3 upgrade --install filebeat elastic/filebeat --version 8.5.1 -f $VALUES_FILE -n $NAMESPACE

# install kibana
cd ../kibana
microk8s.helm3 upgrade --install kibana elastic/kibana --version 8.5.1 -f $VALUES_FILE -n $NAMESPACE

# install metricbeat
cd ../metricbeat
microk8s.helm3 upgrade --install metricbeat elastic/metricbeat --version 8.5.1 -f $VALUES_FILE -n $NAMESPACE

# Change Persistent Volume Claim Reclaim Policy for elasticsearch
microk8s.kubectl get pv | grep Delete | awk '{print$1}' | xargs -I %  microk8s.kubectl patch pv % -p '{"spec":{"persistentVolumeReclaimPolicy":"Retain"}}'
