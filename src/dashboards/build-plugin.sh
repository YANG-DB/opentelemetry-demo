#!/bin/bash

# Fail script on any error
set -e

echo "Checking for NVM installation..."
# Check if NVM is installed
if [ -s "$HOME/.nvm/nvm.sh" ]; then
    . "$HOME/.nvm/nvm.sh"  # This loads NVM
else
    echo "NVM is not installed. Please install NVM and try again."
    exit 1
fi

echo "NVM found. Installing and using Node version 18..."
# Use a Node version lower than 19
nvm install 18
nvm use 18

# Variables
VERSION=$1
BRANCH_NAME=$2


echo "Preparing to clone OpenSearch Dashboards, version: $VERSION..."

# Check if OpenSearch-Dashboards directory already exists and delete if it does
if [ -d "OpenSearch-Dashboards" ]; then
    echo "Existing OpenSearch-Dashboards directory found. Deleting..."
    rm -rf OpenSearch-Dashboards
fi

echo "Cloning OpenSearch Dashboards, version: $VERSION..."
# Clone and setup OpenSearch Dashboards
git clone --branch $VERSION https://github.com/opensearch-project/OpenSearch-Dashboards.git OpenSearch-Dashboards
cd OpenSearch-Dashboards
yarn osd bootstrap 

echo "Cloning Observability plugin, branch: $BRANCH_NAME..."
# Clone and build the Observability plugin
cd plugins
git clone --branch $BRANCH_NAME https://github.com/opensearch-project/dashboards-observability.git
cd dashboards-observability

echo "Building the Observability plugin..."
yarn build 

echo "Build complete. Deleting the local branch..."
# Delete the local branch after build completion
cd ..
rm -rf dashboards-observability

echo "Local branch deleted. Script complete."

# Optionally, return to the original directory
cd ../..
