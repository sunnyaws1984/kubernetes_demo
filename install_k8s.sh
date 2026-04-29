#!/bin/bash
set -x

# Download latest kubectl
curl -LO "https://dl.k8s.io/release/v1.31.0/bin/windows/amd64/kubectl.exe"

# Create a folder for CLI tools (if not exists)
mkdir -p "$HOME/bin"

# Move kubectl there
mv kubectl.exe "$HOME/bin/"

# Add it to PATH if not already
if [[ ":$PATH:" != *":$HOME/bin:"* ]]; then
  echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
  export PATH=$PATH:$HOME/bin
fi

# Verify installation
kubectl version --client
