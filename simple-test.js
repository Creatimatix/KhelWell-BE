const mysql = require('mysql2/promise');

console.log('🔍 Simple Database Connectivity Test');
console.log('====================================');

const config = {
  host: '217.174.152.45',
  port: 3306,
  user: 'khelwell_user',
  password: 'CS6GpqNI70eD,t&e',
  database: 'khelwell_Database',
  connectTimeout: 10000,
  acquireTimeout: 10000
};

async function testConnection() {
  console.log('🔗 Testing connection to ScalaHosting MySQL...');
  console.log(`   Host: ${config.host}:${config.port}`);
  console.log(`   Database: ${config.database}`);
  console.log(`   User: ${config.user}`);
  
  try {
    const connection = await mysql.createConnection(config);
    console.log('✅ SUCCESS: Connected to database!');
    
    const [rows] = await connection.execute('SELECT 1 as test');
    console.log('✅ Query test:', rows[0]);
    
    await connection.end();
    console.log('✅ Connection closed successfully');
    
  } catch (error) {
    console.log('❌ FAILED:', error.message);
    console.log('   Error Code:', error.code);
    console.log('   Error Number:', error.errno);
  }
}

testConnection(); 