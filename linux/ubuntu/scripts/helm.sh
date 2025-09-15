#!/bin/bash -e
################################################################################
##  File:  helm.sh
##  Desc:  Installs Helm
################################################################################

# Source the helpers for use with the script
. /imagegeneration/installers/helpers/install.sh

# Helm version
HELM_VERSION="3.19.0"

helm_arch() {
  case "$(uname -m)" in
    'aarch64') echo 'arm64' ;;
    'x86_64') echo 'amd64' ;;
    'armv7l') echo 'arm' ;;
    *) exit 1 ;;
  esac
}

# Use pinned Helm version
HELM_VER="${HELM_VERSION}"
printf "\n\t🐋 Installing Helm version: %s 🐋\t\n" "${HELM_VER}"

# Download Helm using the version
base_url="https://get.helm.sh"
filename="helm-v${HELM_VER}-linux-$(helm_arch).tar.gz"
download_with_retries "${base_url}/${filename}" "/tmp" "helm.tar.gz"

# Extract and install Helm
cd /tmp
tar -xzf helm.tar.gz
sudo install linux-$(helm_arch)/helm /usr/local/bin/helm

# Clean up
rm -rf /tmp/helm.tar.gz /tmp/linux-$(helm_arch)

# Verify installation
helm version --client
