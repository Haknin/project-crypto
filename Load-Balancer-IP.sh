#!/usr/bin/bash -xe

# Function to get the LoadBalancer IP
get_loadbalancer_ip() {
    kubectl get service flask-app-service -o=jsonpath='{.status.loadBalancer.ingress[0].ip}'
}

# Check if the LoadBalancer IP is empty and wait until it becomes available
while [ -z "$(get_loadbalancer_ip)" ]; do
    echo "Waiting for LoadBalancer IP to be assigned..."
    sleep 10
done

# Get the LoadBalancer IP address
CLUSTER_IP=$(get_loadbalancer_ip)

# Check if CLUSTER_IP is still empty (could be a timeout case) and exit the script
if [ -z "$CLUSTER_IP" ]; then
    echo "Error: LoadBalancer IP not found. Exiting..."
    exit 1
fi

echo "All Set, Crypto Flask App IP: http://$CLUSTER_IP:30300"
