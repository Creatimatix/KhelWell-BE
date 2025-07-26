# KhelWell Backend API

**Your Game. Your Journey. All in One Place**

A robust Node.js/Express.js backend API for the KhelWell sports platform.

## 🚀 Features

- **Authentication & Authorization**: JWT-based auth with role-based access
- **User Management**: Registration, login, profile management
- **Turf Booking System**: Complete booking workflow
- **Event Management**: Sports events and tournaments
- **Payment Integration**: Payment status tracking
- **SMS Integration**: OTP verification with Twilio
- **Database**: MySQL with Sequelize ORM
- **Security**: Rate limiting, CORS, Helmet, input validation

## 📋 Prerequisites

- Node.js (v16 or higher)
- MySQL (v8.0 or higher)
- npm or yarn

## 🛠️ Installation

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd KhelWell-Backend
   ```

2. **Install dependencies:**
   ```bash
   npm install
   ```

3. **Environment Setup:**
   Create a `.env` file in the root directory:
   ```env
   NODE_ENV=development
   PORT=5001
   DB_HOST=localhost
   DB_PORT=3306
   DB_NAME=khelwell_db
   DB_USER=your_username
   DB_PASSWORD=your_password
   JWT_SECRET=your_jwt_secret_key
   JWT_EXPIRE=7d
   TWILIO_ACCOUNT_SID=your_twilio_account_sid
   TWILIO_AUTH_TOKEN=your_twilio_auth_token
   TWILIO_PHONE_NUMBER=your_twilio_phone_number
   CORS_ORIGIN=http://localhost:3000
   ```

4. **Database Setup:**
   ```bash
   # Create database
   mysql -u root -p
   CREATE DATABASE khelwell_db;
   USE khelwell_db;
   
   # Import schema (if you have the SQL file)
   mysql -u root -p khelwell_db < schema.sql
   ```

5. **Run the server:**
   ```bash
   # Development
   npm run dev
   
   # Production
   npm start
   ```

## 🌐 API Endpoints

### Authentication
- `POST /api/auth/register` - User registration
- `POST /api/auth/login` - User login
- `POST /api/auth/logout` - User logout
- `POST /api/auth/verify-otp` - OTP verification
- `GET /api/auth/profile` - Get user profile
- `PUT /api/auth/profile` - Update user profile

### Turfs
- `GET /api/turfs` - Get all turfs
- `GET /api/turfs/:id` - Get turf by ID
- `POST /api/turfs` - Create new turf (Owner/Admin)
- `PUT /api/turfs/:id` - Update turf (Owner/Admin)
- `DELETE /api/turfs/:id` - Delete turf (Owner/Admin)

### Bookings
- `GET /api/bookings` - Get user bookings
- `POST /api/bookings` - Create booking
- `PUT /api/bookings/:id` - Update booking
- `DELETE /api/bookings/:id` - Cancel booking

### Events
- `GET /api/events` - Get all events
- `GET /api/events/:id` - Get event by ID
- `POST /api/events` - Create event (Admin)
- `PUT /api/events/:id` - Update event (Admin)
- `DELETE /api/events/:id` - Delete event (Admin)

### Admin Routes
- `GET /api/admin/users` - Get all users
- `GET /api/admin/turfs` - Get all turfs for approval
- `GET /api/admin/bookings` - Get all bookings
- `PUT /api/admin/turfs/:id/approve` - Approve turf

### Owner Routes
- `GET /api/owner/turfs` - Get owner's turfs
- `GET /api/owner/bookings` - Get turf bookings
- `PUT /api/owner/bookings/:id/status` - Update booking status

## 🗄️ Database Schema

### Core Tables:
- **users**: User accounts and profiles
- **turfs**: Sports facilities
- **events**: Sports events and tournaments
- **bookings**: Turf reservations
- **slots**: Available time slots
- **reviews**: User reviews and ratings
- **notifications**: User notifications

## 🔐 Security Features

- JWT token authentication
- Password hashing with bcrypt
- Rate limiting
- CORS configuration
- Security headers with Helmet
- Input validation and sanitization
- SQL injection protection

## 🚀 Deployment

### Vercel Deployment
1. Install Vercel CLI: `npm i -g vercel`
2. Deploy: `vercel --prod`

### Environment Variables for Production:
```env
NODE_ENV=production
PORT=5001
DB_HOST=your_production_db_host
DB_NAME=your_production_db_name
DB_USER=your_production_db_user
DB_PASSWORD=your_production_db_password
JWT_SECRET=your_production_jwt_secret
CORS_ORIGIN=https://your-frontend-domain.com
```

## 📊 API Response Format

```json
{
  "success": true,
  "message": "Operation successful",
  "data": {
    // Response data
  },
  "error": null
}
```

## 🛠️ Development

### Scripts:
- `npm start` - Start production server
- `npm run dev` - Start development server with nodemon
- `npm test` - Run tests (if configured)

### Project Structure:
```
├── config/          # Database configuration
├── middleware/      # Express middleware
├── models/          # Sequelize models
├── routes/          # API route handlers
├── utils/           # Utility functions
├── server.js        # Main server file
└── package.json     # Dependencies and scripts
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📞 Support

For support and questions:
- Create an issue in the repository
- Contact the development team

---

**KhelWell - Your Game. Your Journey. All in One Place** 