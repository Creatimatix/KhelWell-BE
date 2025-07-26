const { Sequelize } = require('sequelize');
require('dotenv').config({ path: './config.env' });

console.log('🔍 Testing database connection...');
console.log('📋 Connection details:');
console.log(`   Host: ${process.env.DB_HOST}`);
console.log(`   Port: ${process.env.DB_PORT}`);
console.log(`   Database: ${process.env.DB_NAME}`);
console.log(`   User: ${process.env.DB_USER}`);
console.log(`   Password: ${process.env.DB_PASSWORD ? '***' : 'NOT SET'}`);

// Test different host configurations
const hostsToTest = [
  'localhost',
  '127.0.0.1',
  '217.174.152.45'
];

async function testConnection(host) {
  console.log(`\n🔗 Testing connection to ${host}...`);
  
  const sequelize = new Sequelize(
    process.env.DB_NAME,
    process.env.DB_USER,
    process.env.DB_PASSWORD,
    {
      host: host,
      port: process.env.DB_PORT || 3306,
      dialect: 'mysql',
      logging: false,
      pool: {
        max: 1,
        min: 0,
        acquire: 10000,
        idle: 5000
      }
    }
  );

  try {
    await sequelize.authenticate();
    console.log(`✅ SUCCESS: Connected to ${host}`);
    await sequelize.close();
    return true;
  } catch (error) {
    console.log(`❌ FAILED: ${host} - ${error.message}`);
    await sequelize.close();
    return false;
  }
}

async function runTests() {
  for (const host of hostsToTest) {
    const success = await testConnection(host);
    if (success) {
      console.log(`\n🎉 Working host found: ${host}`);
      console.log(`💡 Update your config.env with: DB_HOST=${host}`);
      break;
    }
  }
  
  console.log('\n📝 If all tests fail, check:');
  console.log('   1. Database credentials are correct');
  console.log('   2. Database user has remote access permissions');
  console.log('   3. MySQL is running on ScalaHosting');
  console.log('   4. Firewall allows connections on port 3306');
}

runTests().catch(console.error); 