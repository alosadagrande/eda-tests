#!bin/bash

SECRETUSER="${SECRETUSER:-global-hub-kafka-user}"
NAMESPACE="${NAMESPACE:-multicluster-global-hub}"

export bootstrapServers=`oc get -n ${NAMESPACE} kafka kafka -ojsonpath='{.status.listeners[1].bootstrapServers}'`
for i in $(seq 1 1); do
    kubectl get -n ${NAMESPACE} secret $SECRETUSER -o jsonpath='{.data.ca\.crt}' | base64 -d > ./ca.crt
    kubectl get -n ${NAMESPACE} secret $SECRETUSER -o jsonpath='{.data.user\.crt}' | base64 -d > ./client.crt
    kubectl get -n ${NAMESPACE} secret $SECRETUSER -o jsonpath='{.data.user\.key}' | base64 -d > ./client.key
    #kubectl create -n ${NAMESPACE} secret generic my-consumer-$i --from-literal=bootstrap_server=$bootstrapServers --from-file=ca.crt=./ca.crt --from-file=client.crt=./client.crt --from-file=client.key=./client.key
done
