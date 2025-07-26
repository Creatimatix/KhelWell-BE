# 🚀 KhelWell Backend - ScalaHosting Setup Guide

## 📋 Prerequisites
- ScalaHosting hosting account with SSH access
- Domain name (optional but recommended)
- Node.js knowledge (basic)

## 🔧 Step 1: ScalaHosting MySQL Database Setup

### 1.1 Access Control Panel
1. Login to your ScalaHosting control panel
2. Navigate to "cPanel" or "SPanel"

### 1.2 Create MySQL Database
1. Find "MySQL Databases" section
2. Click "Create New Database"
3. Database name: `turf_booking`
4. Note the full database name (e.g., `username_turf_booking`)

### 1.3 Create Database User
1. Go to "MySQL Users" section
2. Click "Create New User"
3. Username: `khelwell_user`
4. Password: Create a strong password
5. Note the full username (e.g., `username_khelwell_user`)

### 1.4 Assign User to Database
1. Go to "Add User To Database"
2. Select your database and user
3. Grant "ALL PRIVILEGES"

## 🔧 Step 2: Server Setup

### 2.1 SSH Access
```bash
ssh your_username@your-server.scalahosting.com
```

### 2.2 Install Node.js (if not already installed)
```bash
# Check if Node.js is installed
node --version

# If not installed, install via NodeSource
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install PM2 globally
npm install -g pm2
```

### 2.3 Create Application Directory
```bash
mkdir -p ~/public_html/api
cd ~/public_html/api
```

## 🔧 Step 3: Deploy Your Application

### 3.1 Upload Files
```bash
# From your local machine
rsync -avz --exclude 'node_modules' --exclude '.git' --exclude 'config.env' \
  ./ your_username@your-server.scalahosting.com:~/public_html/api/
```

### 3.2 Install Dependencies
```bash
# On the server
cd ~/public_html/api
npm install --production
```

### 3.3 Create Environment File
```bash
# Create config.env file
nano config.env
```

Add your configuration:
```env
# Database Configuration
DB_HOST=localhost
DB_PORT=3306
DB_NAME=yourusername_turf_booking
DB_USER=yourusername_khelwell_user
DB_PASSWORD=your_password_here

# JWT Configuration
JWT_SECRET=your-super-secret-jwt-key
JWT_EXPIRE=7d

# Environment
NODE_ENV=production

# Twilio Configuration (optional)
TWILIO_ACCOUNT_SID=your_account_sid
TWILIO_AUTH_TOKEN=your_auth_token
TWILIO_PHONE_NUMBER=+14155238886

# Frontend URL
FRONTEND_URL=https://your-frontend-domain.com
```

### 3.4 Start Application
```bash
# Start with PM2
pm2 start ecosystem.config.js

# Save PM2 configuration
pm2 save

# Setup PM2 to start on boot
pm2 startup
```

## 🔧 Step 4: Domain Configuration

### 4.1 Create Subdomain (Optional)
1. Go to ScalaHosting control panel
2. Create subdomain: `api.yourdomain.com`
3. Point it to `~/public_html/api`

### 4.2 Configure Reverse Proxy (Recommended)
Create `.htaccess` file in your domain root:
```apache
RewriteEngine On
RewriteRule ^api/(.*)$ http://localhost:3001/$1 [P,L]
```

## 🔧 Step 5: SSL Certificate
1. Go to ScalaHosting control panel
2. Find "SSL/TLS" section
3. Install SSL certificate for your domain

## 🔧 Step 6: Testing

### 6.1 Test Database Connection
```bash
# On the server
cd ~/public_html/api
node -e "
const { testConnection } = require('./config/database');
testConnection().then(() => console.log('Database connected!'));
"
```

### 6.2 Test API Endpoints
```bash
# Test health check
curl https://your-domain.com/api/health

# Test root endpoint
curl https://your-domain.com/api/
```

## 🔧 Step 7: Monitoring and Maintenance

### 7.1 PM2 Commands
```bash
# Check status
pm2 status

# View logs
pm2 logs khelwell-backend

# Restart application
pm2 restart khelwell-backend

# Stop application
pm2 stop khelwell-backend
```

### 7.2 Database Backup
```bash
# Create backup
mysqldump -u yourusername_khelwell_user -p yourusername_turf_booking > backup.sql

# Restore backup
mysql -u yourusername_khelwell_user -p yourusername_turf_booking < backup.sql
```

## 🔧 Step 8: Update Frontend Configuration

Update your frontend environment variables:
```env
REACT_APP_API_URL=https://your-domain.com/api
```

## 🚨 Troubleshooting

### Common Issues:

1. **Database Connection Failed**
   - Check database credentials
   - Ensure database user has proper permissions
   - Verify database host and port

2. **Port Already in Use**
   - Change port in ecosystem.config.js
   - Check if another application is using the port

3. **Permission Denied**
   - Check file permissions: `chmod 755 ~/public_html/api`
   - Ensure proper ownership

4. **PM2 Not Starting**
   - Check logs: `pm2 logs khelwell-backend`
   - Verify Node.js installation
   - Check environment variables

## 📞 Support

If you encounter issues:
1. Check PM2 logs: `pm2 logs khelwell-backend`
2. Check application logs in `~/public_html/api/logs/`
3. Verify database connection
4. Contact ScalaHosting support if server-related

## 🎉 Success!

Your KhelWell backend should now be running on ScalaHosting with:
- ✅ MySQL database connected
- ✅ API endpoints accessible
- ✅ SSL certificate installed
- ✅ PM2 process management
- ✅ Automatic restarts on failure 