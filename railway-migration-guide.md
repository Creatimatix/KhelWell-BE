# 🚂 Railway Database Migration Guide

## 🎯 Why Railway?
- **Easiest migration** - Just export/import data
- **Vercel compatible** - Works perfectly with serverless
- **Free tier** - 500 hours/month
- **Automatic scaling** - No configuration needed

## 📋 Step 1: Export Data from ScalaHosting

### 1.1 SSH into ScalaHosting
```bash
ssh your-username@your-scalahosting-server.com
```

### 1.2 Export Database
```bash
# Export structure and data
mysqldump -u khelwell_user -p khelwell_Database > khelwell_backup.sql

# Export only structure (if you want to start fresh)
mysqldump -u khelwell_user -p --no-data khelwell_Database > khelwell_structure.sql

# Download to your local machine
scp your-username@your-scalahosting-server.com:~/khelwell_backup.sql ./
```

## 🚂 Step 2: Create Railway Database

### 2.1 Sign up for Railway
1. Go to [Railway.app](https://railway.app)
2. Sign up with GitHub
3. Create new project

### 2.2 Add MySQL Database
1. Click **"New Service"**
2. Select **"Database"** → **"MySQL"**
3. Wait for database to be created

### 2.3 Get Connection Details
1. Click on your MySQL service
2. Go to **"Connect"** tab
3. Copy the connection details:
   ```
   Host: your-railway-mysql-host
   Port: 3306
   Database: railway
   Username: root
   Password: your-railway-password
   ```

## 📥 Step 3: Import Data to Railway

### 3.1 Connect to Railway MySQL
```bash
# Connect using the Railway connection details
mysql -h your-railway-mysql-host -P 3306 -u root -p railway
```

### 3.2 Import Your Data
```bash
# Inside MySQL, import your backup
source khelwell_backup.sql;

# Or from command line
mysql -h your-railway-mysql-host -P 3306 -u root -p railway < khelwell_backup.sql
```

## 🔧 Step 4: Update Vercel Backend

### 4.1 Update Environment Variables in Vercel
Go to your Vercel dashboard → Project Settings → Environment Variables:

```env
DB_HOST=your-railway-mysql-host
DB_PORT=3306
DB_NAME=railway
DB_USER=root
DB_PASSWORD=your-railway-password
NODE_ENV=production
JWT_SECRET=your-super-secret-jwt-key
JWT_EXPIRE=7d
```

### 4.2 Enable Database in Backend Code
Update your `server.js`:

```javascript
// Change this line from false to true
const hasDatabaseConfig = true; // Enable database for Vercel
```

### 4.3 Deploy to Vercel
```bash
# Commit and push changes
git add .
git commit -m "Enable database connection for Railway"
git push origin main
```

## 🧪 Step 5: Test the Connection

### 5.1 Test Database Connection
```bash
# Test from your local machine
mysql -h your-railway-mysql-host -P 3306 -u root -p railway -e "SELECT 1 as test;"
```

### 5.2 Test Vercel API
```bash
# Test health endpoint
curl https://khelwell-be.vercel.app/api/health

# Test database endpoint
curl https://khelwell-be.vercel.app/api/auth/login
```

## 💰 Cost Breakdown

| Service | Cost | Details |
|---------|------|---------|
| Railway Database | $5/month | After free tier (500 hours) |
| Vercel Backend | Free | Hobby plan |
| **Total** | **$5/month** | Much cheaper than dedicated hosting |

## 🎯 Benefits of This Setup

✅ **Vercel compatible** - Works with serverless functions  
✅ **Automatic scaling** - No configuration needed  
✅ **High performance** - Optimized for web apps  
✅ **Easy backup** - One-click backups  
✅ **Development tools** - Built-in database browser  
✅ **Team collaboration** - Share with team members  

## 🔄 Migration Checklist

- [ ] Export data from ScalaHosting
- [ ] Create Railway account
- [ ] Create MySQL database on Railway
- [ ] Import data to Railway
- [ ] Update Vercel environment variables
- [ ] Enable database in backend code
- [ ] Deploy to Vercel
- [ ] Test all endpoints
- [ ] Update frontend API URL (if needed)

## 🆘 Troubleshooting

### Connection Issues
```bash
# Test connection from local machine
mysql -h your-railway-host -P 3306 -u root -p railway

# Check if tables exist
SHOW TABLES;
```

### Import Issues
```bash
# If import fails, try with different options
mysql -h your-railway-host -P 3306 -u root -p railway --force < khelwell_backup.sql
```

### Vercel Issues
- Check environment variables are set correctly
- Verify database is enabled in code
- Check Vercel logs for errors

---

**🎉 You're all set!** Your Vercel backend will now connect to Railway MySQL database. 