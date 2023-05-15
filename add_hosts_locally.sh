#!/bin/bash
# Local host that are used to help developing and debugging the OTEL demo locally

# The IP address you want to associate with the hostname
IP="127.0.0.1"

# The hostname you want to associate with the IP address
OPENSEARCH_HOST="opensearch-node1"
OPENSEARCH_DASHBOARD="opensearch-dashboards"
OTEL_STORE="frontend"
OTEL_LOADER="loadgenerator"
PROMETHEUS="prometheus"

# Add the entry to the /etc/hosts file
echo "$IP    $OPENSEARCH_HOST" | sudo tee -a /etc/hosts
echo "$IP    $OPENSEARCH_DASHBOARD" | sudo tee -a /etc/hosts
echo "$IP    $OTEL_STORE" | sudo tee -a /etc/hosts
echo "$IP    $PROMETHEUS" | sudo tee -a /etc/hosts
echo "$IP    $OTEL_LOADER" | sudo tee -a /etc/hosts
