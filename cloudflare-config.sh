#!/bin/bash

# Cloudflare Tunnel Configuration Script
# Run this script after installing cloudflared

echo "🔧 Configuring Cloudflare Tunnel..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get tunnel ID from user
echo -e "${YELLOW}📋 Please provide your tunnel information:${NC}"
echo ""

# Get tunnel ID
read -p "Enter your tunnel ID (from 'cloudflared tunnel list'): " TUNNEL_ID

if [ -z "$TUNNEL_ID" ]; then
    echo -e "${RED}❌ Tunnel ID is required${NC}"
    exit 1
fi

# Get domain
read -p "Enter your domain (e.g., yourdomain.com): " DOMAIN

if [ -z "$DOMAIN" ]; then
    echo -e "${RED}❌ Domain is required${NC}"
    exit 1
fi

# Create config directory
echo "Creating config directory..."
mkdir -p ~/.cloudflared

# Create configuration file
echo "Creating configuration file..."
cat > ~/.cloudflared/config.yml << EOF
tunnel: $TUNNEL_ID
credentials-file: ~/.cloudflared/$TUNNEL_ID.json

ingress:
  - hostname: mysql.$DOMAIN
    service: tcp://localhost:3306
  - service: http_status:404
EOF

echo -e "${GREEN}✅ Configuration file created: ~/.cloudflared/config.yml${NC}"

# Test the configuration
echo "Testing configuration..."
cloudflared tunnel --config ~/.cloudflared/config.yml ingress validate

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Configuration is valid!${NC}"
else
    echo -e "${RED}❌ Configuration validation failed${NC}"
    exit 1
fi

# Create systemd service for auto-start
echo "Creating systemd service..."
sudo tee /etc/systemd/system/cloudflared.service > /dev/null << EOF
[Unit]
Description=Cloudflare Tunnel
After=network.target

[Service]
Type=simple
User=$USER
ExecStart=/usr/bin/cloudflared tunnel --config ~/.cloudflared/config.yml run
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# Enable and start the service
echo "Enabling and starting service..."
sudo systemctl daemon-reload
sudo systemctl enable cloudflared
sudo systemctl start cloudflared

# Check service status
echo "Checking service status..."
sudo systemctl status cloudflared --no-pager -l

echo ""
echo -e "${GREEN}🎉 Cloudflare Tunnel configured successfully!${NC}"
echo ""
echo -e "${YELLOW}📋 Configuration Summary:${NC}"
echo "   Tunnel ID: $TUNNEL_ID"
echo "   Domain: $DOMAIN"
echo "   MySQL Hostname: mysql.$DOMAIN"
echo "   Service: Enabled and running"
echo ""
echo -e "${YELLOW}🔍 Test the tunnel:${NC}"
echo "   mysql -h mysql.$DOMAIN -P 3306 -u khelwell_user -p khelwell_Database"
echo ""
echo -e "${YELLOW}📝 Next Steps:${NC}"
echo "1. Update your Vercel environment variables:"
echo "   DB_HOST=mysql.$DOMAIN"
echo "   DB_PORT=3306"
echo "   DB_NAME=khelwell_Database"
echo "   DB_USER=khelwell_user"
echo "   DB_PASSWORD=CS6GpqNI70eD,t&e"
echo ""
echo "2. Enable database in your backend code"
echo "3. Deploy to Vercel"
echo "4. Test the connection"
echo ""
echo -e "${GREEN}✅ Configuration script completed!${NC}" 