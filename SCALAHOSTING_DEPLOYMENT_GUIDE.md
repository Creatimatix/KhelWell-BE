# 🚀 KhelWell Backend Deployment Guide for ScalaHosting

## 📋 Overview
This guide will help you deploy the KhelWell backend to ScalaHosting and connect it to your MySQL database.

## 🎯 Current Setup
- **Frontend**: Deployed on Vercel
- **Backend**: Will be deployed on ScalaHosting
- **Database**: MySQL on ScalaHosting

## 📦 Prerequisites
1. ScalaHosting account with SSH access
2. MySQL database already created on ScalaHosting
3. Node.js installed on ScalaHosting (contact support if not available)
4. PM2 installed on ScalaHosting (`npm install -g pm2`)

## 🔧 Step 1: Prepare Your Local Environment

### 1.1 Update Production Configuration
Edit `config.env.production` with your actual ScalaHosting credentials:

```env
PORT=5001

# MySQL Database Configuration (ScalaHosting - Local Connection)
DB_HOST=localhost
DB_PORT=3306
DB_NAME=khelwell_Database
DB_USER=khelwell_user
DB_PASSWORD=CS6GpqNI70eD,t&e

# JWT Configuration
JWT_SECRET=your-super-secret-jwt-key-change-this-in-production
JWT_EXPIRE=7d

# Environment
NODE_ENV=production

# Twilio Configuration (for OTP)
TWILIO_ACCOUNT_SID=your_account_sid_here
TWILIO_AUTH_TOKEN=your_auth_token_here
TWILIO_PHONE_NUMBER=+14155238886

# Frontend URL (for CORS)
FRONTEND_URL=https://your-frontend-domain.com
```

### 1.2 Create Deployment Package
Run the deployment script:
```bash
chmod +x deploy-to-scalahosting.sh
./deploy-to-scalahosting.sh
```

This will create:
- `khelwell-backend.tar.gz` (deployment package)
- `ecosystem.config.js` (PM2 configuration)
- `.htaccess` (reverse proxy configuration)

## 🚀 Step 2: Deploy to ScalaHosting

### 2.1 Upload Files
Upload the following files to your ScalaHosting server:
- `khelwell-backend.tar.gz`
- `config.env.production`

### 2.2 SSH into Your Server
```bash
ssh your-username@your-scalahosting-server.com
```

### 2.3 Create API Directory
```bash
mkdir -p ~/public_html/api
cd ~/public_html/api
```

### 2.4 Extract and Setup
```bash
# Extract the deployment package
tar -xzf khelwell-backend.tar.gz

# Copy production config
cp config.env.production config.env

# Install dependencies
npm install --production

# Create logs directory
mkdir logs
```

### 2.5 Install PM2 (if not already installed)
```bash
npm install -g pm2
```

### 2.6 Start the Application
```bash
# Start with PM2
pm2 start ecosystem.config.js

# Save PM2 configuration
pm2 save

# Setup PM2 to start on boot
pm2 startup
```

## 🌐 Step 3: Configure Domain and SSL

### 3.1 Domain Configuration
In your ScalaHosting control panel:
1. Go to **Domains** → **Add Domain**
2. Add your API domain (e.g., `api.yourdomain.com`)
3. Point it to the `public_html/api` directory

### 3.2 SSL Certificate
1. Go to **SSL/TLS** in your control panel
2. Install SSL certificate for your API domain
3. Enable **Force HTTPS**

### 3.3 Update Frontend Configuration
Update your frontend's API URL to point to your new ScalaHosting backend:
```env
REACT_APP_API_URL=https://api.yourdomain.com
```

## 🔍 Step 4: Testing

### 4.1 Test API Endpoints
```bash
# Health check
curl https://api.yourdomain.com/api/health

# Test database connection
curl https://api.yourdomain.com/api/auth/login
```

### 4.2 Check PM2 Status
```bash
pm2 status
pm2 logs khelwell-backend
```

### 4.3 Monitor Application
```bash
# View real-time logs
pm2 logs khelwell-backend --lines 100

# Monitor resources
pm2 monit
```

## 🛠️ Step 5: Troubleshooting

### 5.1 Common Issues

#### Database Connection Error
```bash
# Check if MySQL is running
sudo systemctl status mysql

# Test database connection manually
mysql -u khelwell_user -p khelwell_Database
```

#### Port Already in Use
```bash
# Check what's using port 5001
lsof -i :5001

# Kill the process if needed
kill -9 <PID>
```

#### PM2 Issues
```bash
# Restart the application
pm2 restart khelwell-backend

# Delete and recreate
pm2 delete khelwell-backend
pm2 start ecosystem.config.js
```

### 5.2 Log Files
Check these log files for errors:
- `logs/err.log` - Error logs
- `logs/out.log` - Output logs
- `logs/combined.log` - Combined logs

## 🔄 Step 6: Updates and Maintenance

### 6.1 Deploy Updates
1. Create new deployment package locally
2. Upload to server
3. Extract and restart:
```bash
cd ~/public_html/api
tar -xzf khelwell-backend.tar.gz
pm2 restart khelwell-backend
```

### 6.2 Backup Database
```bash
# Create backup
mysqldump -u khelwell_user -p khelwell_Database > backup_$(date +%Y%m%d).sql

# Restore if needed
mysql -u khelwell_user -p khelwell_Database < backup_file.sql
```

## 📞 Support

If you encounter issues:
1. Check PM2 logs: `pm2 logs khelwell-backend`
2. Check application logs in `logs/` directory
3. Contact ScalaHosting support for server-related issues
4. Check this guide for common solutions

## ✅ Success Checklist

- [ ] Backend deployed to ScalaHosting
- [ ] Database connection working
- [ ] API endpoints responding
- [ ] SSL certificate installed
- [ ] Frontend updated with new API URL
- [ ] PM2 configured for auto-restart
- [ ] Logs being generated
- [ ] Application monitoring set up

---

**🎉 Congratulations!** Your KhelWell backend is now successfully deployed on ScalaHosting and connected to your MySQL database. 