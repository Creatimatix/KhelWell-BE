const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');

// Load environment variables
dotenv.config({ path: './config.env' });

// Import database configuration
const { sequelize, testConnection } = require('./config/database');

// Import models
const User = require('./models/User');
const Turf = require('./models/Turf');
const Booking = require('./models/Booking');
const Event = require('./models/Event');
const Slot = require('./models/Slot');
const Notification = require('./models/Notification');
const OTP = require('./models/OTP');
const Review = require('./models/Review');

// Import routes
const authRoutes = require('./routes/auth');
const turfRoutes = require('./routes/turfs');
const bookingRoutes = require('./routes/bookings');
const eventRoutes = require('./routes/events');
const userRoutes = require('./routes/users');
const adminRoutes = require('./routes/admin');
const slotRoutes = require('./routes/slots');
const notificationRoutes = require('./routes/notifications');
const ownerRoutes = require('./routes/owner');
const otpRoutes = require('./routes/otp');
const reviewRoutes = require('./routes/reviews');

const app = express();

// Middleware
app.use(cors({
  origin: [
    'http://localhost:3000', 
    'http://127.0.0.1:3000',
    'https://khelwell-fe.vercel.app',
    'https://khelwell-frontend.vercel.app',
    'https://khelwell.vercel.app',
    process.env.FRONTEND_URL || 'https://khelwell-fe.vercel.app'
  ],
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization', 'X-Requested-With']
}));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Database connection and sync
const initializeDatabase = async () => {
  try {
    // Check if required environment variables are set
    const requiredEnvVars = ['DB_HOST', 'DB_USER', 'DB_PASSWORD', 'DB_NAME'];
    const missingVars = requiredEnvVars.filter(varName => !process.env[varName]);
    
    if (missingVars.length > 0) {
      console.error('❌ Missing required environment variables:', missingVars);
      console.log('Please set the following environment variables in Vercel:');
      missingVars.forEach(varName => console.log(`- ${varName}`));
      return false;
    }

    await testConnection();
    
    // Set up model associations
    Turf.hasMany(Review, { foreignKey: 'turf_id', as: 'reviews' });
    Review.belongsTo(User, { foreignKey: 'user_id', as: 'user' });
    Review.belongsTo(Turf, { foreignKey: 'turf_id', as: 'turf' });
    
    await sequelize.sync({ alter: true });
    console.log('✅ Database synchronized successfully');
    return true;
  } catch (error) {
    console.error('❌ Database initialization error:', error);
    console.log('Please make sure MySQL is running and credentials are correct');
    return false;
  }
};

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/turfs', turfRoutes);
app.use('/api/bookings', bookingRoutes);
app.use('/api/events', eventRoutes);
app.use('/api/users', userRoutes);
app.use('/api/admin', adminRoutes);
app.use('/api/slots', slotRoutes);
app.use('/api/notifications', notificationRoutes);
app.use('/api/owner', ownerRoutes);
app.use('/api/otp', otpRoutes);
app.use('/api/reviews', reviewRoutes);

// Health check route
app.get('/api/health', (req, res) => {
  res.json({ 
    status: 'OK', 
    message: 'Turf Booking API is running',
    environment: process.env.NODE_ENV || 'development',
    timestamp: new Date().toISOString()
  });
});

// Root route for basic testing
app.get('/', (req, res) => {
  res.json({ 
    message: 'KhelWell Backend API',
    version: '1.0.0',
    status: 'running'
  });
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error('❌ Error occurred:', err);
  console.error('❌ Error stack:', err.stack);
  
  // Don't expose internal errors in production
  const message = process.env.NODE_ENV === 'production' 
    ? 'Something went wrong!' 
    : err.message;
    
  res.status(500).json({ 
    message,
    error: process.env.NODE_ENV === 'development' ? err.message : undefined
  });
});

// 404 handler
app.use('*', (req, res) => {
  res.status(404).json({ message: 'Route not found' });
});

const PORT = process.env.PORT || 5001;

// Initialize database and start server
const startServer = async () => {
  await initializeDatabase();
  
  if (process.env.NODE_ENV !== 'production') {
    app.listen(PORT, () => {
      console.log(`🚀 Server running on port ${PORT}`);
      console.log(`📊 API Health: http://localhost:${PORT}/api/health`);
    });
  }
};

// For Vercel serverless deployment
if (process.env.NODE_ENV === 'production') {
  // Initialize database without starting server
  initializeDatabase().catch((error) => {
    console.error('❌ Failed to initialize database in production:', error);
    // Don't throw error to prevent function crash
  });
}

// Start server only in development
if (process.env.NODE_ENV !== 'production') {
  startServer().catch(console.error);
}

// Export for Vercel
module.exports = app; 