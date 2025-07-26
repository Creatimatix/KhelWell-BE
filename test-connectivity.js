const { Sequelize } = require('sequelize');
require('dotenv').config({ path: './config.env' });

console.log('🔍 Testing Database Connectivity from Different Environments');
console.log('========================================================');

// Test configurations
const testConfigs = [
  {
    name: 'ScalaHosting MySQL (External)',
    host: '217.174.152.45',
    port: 3306,
    database: 'khelwell_Database',
    username: 'khelwell_user',
    password: 'CS6GpqNI70eD,t&e'
  },
  {
    name: 'Localhost (Same Server)',
    host: 'localhost',
    port: 3306,
    database: 'khelwell_Database',
    username: 'khelwell_user',
    password: 'CS6GpqNI70eD,t&e'
  },
  {
    name: '127.0.0.1 (Same Server)',
    host: '127.0.0.1',
    port: 3306,
    database: 'khelwell_Database',
    username: 'khelwell_user',
    password: 'CS6GpqNI70eD,t&e'
  }
];

async function testConnection(config) {
  console.log(`\n🔗 Testing: ${config.name}`);
  console.log(`   Host: ${config.host}:${config.port}`);
  console.log(`   Database: ${config.database}`);
  console.log(`   User: ${config.username}`);
  
  const sequelize = new Sequelize(
    config.database,
    config.username,
    config.password,
    {
      host: config.host,
      port: config.port,
      dialect: 'mysql',
      logging: false,
      pool: {
        max: 1,
        min: 0,
        acquire: 10000,
        idle: 5000
      },
      dialectOptions: {
        connectTimeout: 60000,
        acquireTimeout: 60000,
        timeout: 60000
      }
    }
  );

  try {
    const startTime = Date.now();
    await sequelize.authenticate();
    const endTime = Date.now();
    
    console.log(`✅ SUCCESS: Connected in ${endTime - startTime}ms`);
    
    // Test a simple query
    const [results] = await sequelize.query('SELECT 1 as test');
    console.log(`✅ Query test: ${JSON.stringify(results[0])}`);
    
    await sequelize.close();
    return { success: true, time: endTime - startTime };
  } catch (error) {
    console.log(`❌ FAILED: ${error.message}`);
    console.log(`   Error Code: ${error.code || 'N/A'}`);
    console.log(`   Error Number: ${error.errno || 'N/A'}`);
    await sequelize.close();
    return { success: false, error: error.message };
  }
}

async function runAllTests() {
  console.log('🚀 Starting connectivity tests...\n');
  
  const results = [];
  
  for (const config of testConfigs) {
    const result = await testConnection(config);
    results.push({ ...config, ...result });
  }
  
  console.log('\n📊 Test Results Summary:');
  console.log('========================');
  
  results.forEach((result, index) => {
    const status = result.success ? '✅ PASS' : '❌ FAIL';
    console.log(`${index + 1}. ${result.name}: ${status}`);
    if (result.success) {
      console.log(`   Response time: ${result.time}ms`);
    } else {
      console.log(`   Error: ${result.error}`);
    }
  });
  
  console.log('\n💡 Analysis:');
  console.log('============');
  
  const workingConnections = results.filter(r => r.success);
  const failedConnections = results.filter(r => !r.success);
  
  if (workingConnections.length > 0) {
    console.log('✅ Working connections found!');
    workingConnections.forEach(conn => {
      console.log(`   - ${conn.name} (${conn.time}ms)`);
    });
  }
  
  if (failedConnections.length > 0) {
    console.log('❌ Failed connections:');
    failedConnections.forEach(conn => {
      console.log(`   - ${conn.name}: ${conn.error}`);
    });
  }
  
  console.log('\n🎯 Recommendations:');
  console.log('==================');
  
  if (workingConnections.length === 0) {
    console.log('❌ No working connections found.');
    console.log('   - Check if MySQL is running on ScalaHosting');
    console.log('   - Verify database credentials');
    console.log('   - Check firewall settings');
    console.log('   - Contact ScalaHosting support');
  } else if (workingConnections.some(c => c.host === 'localhost' || c.host === '127.0.0.1')) {
    console.log('✅ Local connections work - deploy backend to ScalaHosting!');
    console.log('   - Use localhost connection for same-server deployment');
    console.log('   - This will give you full database functionality');
  } else {
    console.log('⚠️ Only external connections work');
    console.log('   - Vercel cannot connect to external MySQL');
    console.log('   - Consider using a database proxy service');
    console.log('   - Or migrate to a cloud database service');
  }
}

// Run the tests
runAllTests().catch(console.error); 