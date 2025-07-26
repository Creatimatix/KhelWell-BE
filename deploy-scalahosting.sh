#!/bin/bash

# KhelWell Backend Deployment Script for ScalaHosting
# Make sure to update the paths and credentials below

echo "🚀 Starting KhelWell Backend deployment to ScalaHosting..."

# Update these variables with your actual ScalaHosting details
SCALAHOSTING_USERNAME="your_scalahosting_username"
SCALAHOSTING_HOST="your-server.scalahosting.com"
REMOTE_PATH="/home/$SCALAHOSTING_USERNAME/public_html/api"
LOCAL_PATH="./"

# Create remote directory if it doesn't exist
echo "📁 Creating remote directory..."
ssh $SCALAHOSTING_USERNAME@$SCALAHOSTING_HOST "mkdir -p $REMOTE_PATH"

# Copy files to server
echo "📤 Uploading files to ScalaHosting..."
rsync -avz --exclude 'node_modules' --exclude '.git' --exclude 'config.env' $LOCAL_PATH $SCALAHOSTING_USERNAME@$SCALAHOSTING_HOST:$REMOTE_PATH

# Install dependencies on server
echo "📦 Installing dependencies..."
ssh $SCALAHOSTING_USERNAME@$SCALAHOSTING_HOST "cd $REMOTE_PATH && npm install --production"

# Set proper permissions
echo "🔐 Setting permissions..."
ssh $SCALAHOSTING_USERNAME@$SCALAHOSTING_HOST "chmod 755 $REMOTE_PATH"

# Create PM2 ecosystem file for process management
echo "⚙️ Creating PM2 configuration..."
cat > ecosystem.config.js << EOF
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
      PORT: 3001
    }
  }]
};
EOF

# Upload PM2 config
scp ecosystem.config.js $SCALAHOSTING_USERNAME@$SCALAHOSTING_HOST:$REMOTE_PATH/

# Start/restart the application
echo "🔄 Starting application..."
ssh $SCALAHOSTING_USERNAME@$SCALAHOSTING_HOST "cd $REMOTE_PATH && pm2 delete khelwell-backend 2>/dev/null || true"
ssh $SCALAHOSTING_USERNAME@$SCALAHOSTING_HOST "cd $REMOTE_PATH && pm2 start ecosystem.config.js"
ssh $SCALAHOSTING_USERNAME@$SCALAHOSTING_HOST "pm2 save"

echo "✅ Deployment completed!"
echo "🌐 Your API should be available at: https://your-domain.com/api"
echo "📊 Check PM2 status: ssh $SCALAHOSTING_USERNAME@$SCALAHOSTING_HOST 'pm2 status'" 