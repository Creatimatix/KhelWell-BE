# 🚀 Cloudflare Tunnel Quick Start Guide

## 📋 Prerequisites

Before starting, make sure you have:
- ✅ **Cloudflare account** (free at [cloudflare.com](https://cloudflare.com))
- ✅ **Domain managed by Cloudflare** (add your domain to Cloudflare)
- ✅ **SSH access to ScalaHosting server**
- ✅ **MySQL running on ScalaHosting**

## 🎯 Step-by-Step Setup

### **Step 1: SSH into ScalaHosting Server**
```bash
ssh your-username@your-scalahosting-server.com
```

### **Step 2: Run the Setup Script**
```bash
# Download the setup script to your server
wget https://raw.githubusercontent.com/your-repo/KhelWell-BE/main/cloudflare-setup.sh
chmod +x cloudflare-setup.sh
./cloudflare-setup.sh
```

**What this does:**
- Downloads and installs `cloudflared`
- Authenticates with your Cloudflare account
- Creates a tunnel for your MySQL database

### **Step 3: Run the Configuration Script**
```bash
# Download the config script
wget https://raw.githubusercontent.com/your-repo/KhelWell-BE/main/cloudflare-config.sh
chmod +x cloudflare-config.sh
./cloudflare-config.sh
```

**What this does:**
- Creates tunnel configuration
- Sets up auto-start service
- Provides you with the MySQL hostname

### **Step 4: Update Vercel Environment Variables**

Go to your Vercel dashboard → Project Settings → Environment Variables:

```env
DB_HOST=mysql.yourdomain.com
DB_PORT=3306
DB_NAME=khelwell_Database
DB_USER=khelwell_user
DB_PASSWORD=CS6GpqNI70eD,t&e
NODE_ENV=production
JWT_SECRET=your-super-secret-jwt-key
JWT_EXPIRE=7d
```

### **Step 5: Enable Database in Backend**

Update your `server.js`:

```javascript
// Change this line from false to true
const hasDatabaseConfig = true; // Enable database for Vercel
```

### **Step 6: Deploy to Vercel**
```bash
git add .
git commit -m "Enable database connection for Cloudflare Tunnel"
git push origin main
```

## 🧪 Testing

### **Test 1: Local Connection**
```bash
# Test from your local machine
mysql -h mysql.yourdomain.com -P 3306 -u khelwell_user -p khelwell_Database
```

### **Test 2: Vercel API**
```bash
# Test health endpoint
curl https://khelwell-be.vercel.app/api/health

# Test database endpoint
curl https://khelwell-be.vercel.app/api/auth/login
```

## 🔧 Troubleshooting

### **Tunnel Not Working**
```bash
# Check tunnel status
sudo systemctl status cloudflared

# Check tunnel logs
sudo journalctl -u cloudflared -f

# Restart tunnel
sudo systemctl restart cloudflared
```

### **Connection Issues**
```bash
# Test tunnel connectivity
cloudflared tunnel --config ~/.cloudflared/config.yml ingress validate

# Check if MySQL is running
sudo systemctl status mysql
```

### **Domain Issues**
- Make sure your domain is added to Cloudflare
- Check DNS settings in Cloudflare dashboard
- Verify the subdomain `mysql.yourdomain.com` is created

## 📊 Expected Results

After successful setup:

✅ **Tunnel Status**: Running  
✅ **Local Connection**: `mysql -h mysql.yourdomain.com` works  
✅ **Vercel API**: Responds with database data  
✅ **Auto-restart**: Tunnel starts automatically on server reboot  

## 💰 Cost

- **Cloudflare Tunnel**: Free
- **Custom Domain**: $0.50/month (optional)
- **Total**: $0.50/month or free

## 🆘 Support

If you encounter issues:

1. **Check tunnel logs**: `sudo journalctl -u cloudflared -f`
2. **Verify configuration**: `cloudflared tunnel --config ~/.cloudflared/config.yml ingress validate`
3. **Test MySQL locally**: `mysql -u khelwell_user -p khelwell_Database`
4. **Check Cloudflare dashboard** for tunnel status

---

**🎉 You're all set!** Your Vercel backend will now connect to your ScalaHosting MySQL database through Cloudflare Tunnel. 