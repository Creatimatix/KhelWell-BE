#!/bin/bash

# Cloudflare Tunnel Setup Script for ScalaHosting
# Run this script on your ScalaHosting server

echo "🚀 Setting up Cloudflare Tunnel on ScalaHosting..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    echo -e "${RED}❌ Don't run this script as root. Use your regular user account.${NC}"
    exit 1
fi

echo -e "${YELLOW}📋 Prerequisites:${NC}"
echo "   - Cloudflare account (free)"
echo "   - Domain managed by Cloudflare"
echo "   - SSH access to ScalaHosting server"
echo ""

# Step 1: Download and Install Cloudflare Tunnel
echo -e "${YELLOW}📥 Step 1: Installing Cloudflare Tunnel...${NC}"

# Download the latest version
echo "Downloading cloudflared..."
wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Downloaded cloudflared successfully${NC}"
else
    echo -e "${RED}❌ Failed to download cloudflared${NC}"
    exit 1
fi

# Install the package
echo "Installing cloudflared..."
sudo dpkg -i cloudflared-linux-amd64.deb

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Installed cloudflared successfully${NC}"
else
    echo -e "${RED}❌ Failed to install cloudflared${NC}"
    exit 1
fi

# Clean up download
rm cloudflared-linux-amd64.deb

# Verify installation
echo "Verifying installation..."
cloudflared --version

echo ""
echo -e "${GREEN}✅ Cloudflare Tunnel installed successfully!${NC}"
echo ""

# Step 2: Authentication
echo -e "${YELLOW}🔐 Step 2: Authenticate with Cloudflare${NC}"
echo "This will open your browser to authenticate with Cloudflare."
echo "Make sure you have:"
echo "   - A Cloudflare account"
echo "   - A domain managed by Cloudflare"
echo ""
read -p "Press Enter to continue with authentication..."

# Authenticate with Cloudflare
cloudflared tunnel login

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Authentication successful!${NC}"
else
    echo -e "${RED}❌ Authentication failed. Please try again.${NC}"
    exit 1
fi

# Step 3: Create Tunnel
echo ""
echo -e "${YELLOW}🌐 Step 3: Creating Tunnel${NC}"

# Create tunnel
echo "Creating tunnel..."
TUNNEL_NAME="khelwell-mysql"
cloudflared tunnel create $TUNNEL_NAME

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Tunnel created successfully!${NC}"
else
    echo -e "${RED}❌ Failed to create tunnel${NC}"
    exit 1
fi

# List tunnels to get the tunnel ID
echo "Listing tunnels..."
cloudflared tunnel list

echo ""
echo -e "${GREEN}🎉 Cloudflare Tunnel setup completed!${NC}"
echo ""
echo -e "${YELLOW}📋 Next Steps:${NC}"
echo "1. Note down your tunnel ID from the list above"
echo "2. Create the configuration file (see next script)"
echo "3. Start the tunnel"
echo "4. Update your Vercel environment variables"
echo ""
echo -e "${YELLOW}📝 Configuration file will be created in:${NC}"
echo "   ~/.cloudflared/config.yml"
echo ""
echo -e "${GREEN}✅ Setup script completed!${NC}" 