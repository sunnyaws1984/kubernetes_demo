#!/bin/bash

set -e

echo "Installing Helm on Windows..."

# Download Helm install package
curl -LO https://get.helm.sh/helm-v3.20.2-windows-amd64.zip

# Extract
unzip helm-v3.20.2-windows-amd64.zip

# Move helm.exe to a directory already in PATH
mkdir -p "$HOME/bin"

mv windows-amd64/helm.exe "$HOME/bin/helm.exe"

echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc

export PATH="$HOME/bin:$PATH"

# Verify
helm version

echo "Helm installed successfully."
