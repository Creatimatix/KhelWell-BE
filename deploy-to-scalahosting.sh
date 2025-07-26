#!/bin/bash

# KhelWell Backend Deployment Script for ScalaHosting
# This script deploys the backend to ScalaHosting server

echo "🚀 Starting KhelWell Backend deployment to ScalaHosting..."

# Configuration
REMOTE_HOST="your-scalahosting-server.com"  # Replace with your actual server
REMOTE_USER="your-username"                 # Replace with your ScalaHosting username
REMOTE_PATH="/home/$REMOTE_USER/public_html/api"  # Path on ScalaHosting
LOCAL_PATH="./"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}📋 Deployment Configuration:${NC}"
echo "   Remote Host: $REMOTE_HOST"
echo "   Remote User: $REMOTE_USER"
echo "   Remote Path: $REMOTE_PATH"
echo "   Local Path: $LOCAL_PATH"

# Check if required tools are installed
if ! command -v rsync &> /dev/null; then
    echo -e "${RED}❌ rsync is not installed. Please install it first.${NC}"
    exit 1
fi

# Create production config
echo -e "${YELLOW}📝 Creating production configuration...${NC}"
cp config.env.example config.env.production

echo -e "${GREEN}✅ Production config created. Please edit config.env.production with your ScalaHosting database credentials.${NC}"
echo ""
echo -e "${YELLOW}📋 Required environment variables for config.env.production:${NC}"
echo "   DB_HOST=localhost"
echo "   DB_PORT=3306"
echo "   DB_NAME=your_database_name"
echo "   DB_USER=your_database_user"
echo "   DB_PASSWORD=your_database_password"
echo "   JWT_SECRET=your_jwt_secret"
echo "   JWT_EXPIRE=7d"
echo "   NODE_ENV=production"
echo "   PORT=5001"
echo ""

# Ask user to confirm before proceeding
read -p "Have you updated config.env.production with your ScalaHosting credentials? (y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}⏸️ Please update config.env.production and run this script again.${NC}"
    exit 1
fi

# Create .htaccess for reverse proxy (if using Apache)
echo -e "${YELLOW}📝 Creating .htaccess for reverse proxy...${NC}"
cat > .htaccess << 'EOF'
RewriteEngine On
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule ^(.*)$ http://localhost:5001/$1 [P,L]

# Security headers
Header always set X-Content-Type-Options nosniff
Header always set X-Frame-Options DENY
Header always set X-XSS-Protection "1; mode=block"
Header always set Referrer-Policy "strict-origin-when-cross-origin"
EOF

echo -e "${GREEN}✅ .htaccess created for reverse proxy${NC}"

# Create PM2 ecosystem file
echo -e "${YELLOW}📝 Creating PM2 ecosystem configuration...${NC}"
cat > ecosystem.config.js << 'EOF'
module.exports = {
  apps: [{
    name: 'khelwell-backend',
    script: 'server.js',
    instances: 1,
    autorestart: true,
    watch: false,
    max_memory_restart: '1G',
    env: {
      NODE_ENV: 'production',
      PORT: 5001
    },
    error_file: './logs/err.log',
    out_file: './logs/out.log',
    log_file: './logs/combined.log',
    time: true
  }]
};
EOF

echo -e "${GREEN}✅ PM2 ecosystem config created${NC}"

# Create deployment package
echo -e "${YELLOW}📦 Creating deployment package...${NC}"
tar -czf khelwell-backend.tar.gz \
    --exclude='node_modules' \
    --exclude='.git' \
    --exclude='.env' \
    --exclude='config.env' \
    --exclude='*.log' \
    --exclude='logs' \
    .

echo -e "${GREEN}✅ Deployment package created: khelwell-backend.tar.gz${NC}"

echo ""
echo -e "${GREEN}🎉 Deployment package ready!${NC}"
echo ""
echo -e "${YELLOW}📋 Next steps:${NC}"
echo "1. Upload khelwell-backend.tar.gz to your ScalaHosting server"
echo "2. SSH into your ScalaHosting server"
echo "3. Extract the package: tar -xzf khelwell-backend.tar.gz"
echo "4. Copy config.env.production to config.env"
echo "5. Install dependencies: npm install --production"
echo "6. Create logs directory: mkdir logs"
echo "7. Start the application: pm2 start ecosystem.config.js"
echo "8. Save PM2 configuration: pm2 save && pm2 startup"
echo ""
echo -e "${YELLOW}📋 Manual deployment commands:${NC}"
echo "scp khelwell-backend.tar.gz $REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH/"
echo "ssh $REMOTE_USER@$REMOTE_HOST"
echo "cd $REMOTE_PATH"
echo "tar -xzf khelwell-backend.tar.gz"
echo "cp config.env.production config.env"
echo "npm install --production"
echo "mkdir logs"
echo "pm2 start ecosystem.config.js"
echo "pm2 save && pm2 startup"
echo ""
echo -e "${GREEN}✅ Deployment script completed!${NC}" 