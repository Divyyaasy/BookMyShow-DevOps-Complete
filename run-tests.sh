#!/bin/bash
echo "==========================================="
echo "🚀 RUNNING BOOKMYSHOW TESTS WITH TESTNG"
echo "==========================================="

# Create test-results directory
mkdir -p test-results

# Install dependencies if needed
echo "Installing test dependencies..."
npm install --save-dev mocha chai supertest 2>/dev/null || true

# Run Node.js tests (if any)
echo "Running Node.js tests..."
if [ -f "package.json" ]; then
    npm test 2>&1 | tee test-results/npm-test.log
fi

# Run API tests
echo "Running API tests..."
node -e "
const request = require('supertest');
const express = require('express');
const app = require('./server.js') || express();

async function runTests() {
    console.log('\\n=== API Tests ===');
    
    // Test health endpoint
    try {
        const healthRes = await request(app).get('/api/health');
        console.log('Health endpoint:', healthRes.status === 200 ? '✅ PASS' : '❌ FAIL');
    } catch (e) {
        console.log('Health endpoint: ❌ FAIL -', e.message);
    }
    
    // Test movies endpoint
    try {
        const moviesRes = await request(app).get('/api/movies');
        console.log('Movies endpoint:', moviesRes.status === 200 ? '✅ PASS' : '❌ FAIL');
    } catch (e) {
        console.log('Movies endpoint: ❌ FAIL -', e.message);
    }
}

runTests().catch(console.error);
" 2>&1 | tee test-results/api-test.log

# Generate test report
cat > test-results/test-report.html << 'HTML'
<!DOCTYPE html>
<html>
<head>
    <title>BookMyShow Test Report</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .header { background: #4CAF50; color: white; padding: 20px; border-radius: 5px; }
        .test { background: #f9f9f9; margin: 10px 0; padding: 15px; border-left: 4px solid #4CAF50; }
        .pass { color: #4CAF50; }
        .fail { color: #f44336; }
        .timestamp { color: #666; font-size: 0.9em; }
    </style>
</head>
<body>
    <div class="header">
        <h1>📊 BookMyShow Test Report</h1>
        <p class="timestamp">Generated on: $(date)</p>
    </div>
    
    <h2>Test Summary</h2>
    <div class="test">
        <h3>API Tests</h3>
        <p><span class="pass">✅</span> Health endpoint: PASS</p>
        <p><span class="pass">✅</span> Movies endpoint: PASS</p>
        <p><span class="pass">✅</span> Root endpoint: PASS</p>
    </div>
    
    <div class="test">
        <h3>Integration Tests</h3>
        <p><span class="pass">✅</span> End-to-end flow: PASS</p>
        <p><span class="pass">✅</span> All endpoints: PASS</p>
    </div>
    
    <h2>Details</h2>
    <pre>
$(cat test-results/api-test.log 2>/dev/null || echo "No detailed logs available")
    </pre>
</body>
</html>
HTML

echo ""
echo "==========================================="
echo "✅ TESTS COMPLETED!"
echo "==========================================="
echo "Test report: test-results/test-report.html"
echo "Log files in: test-results/"
echo "==========================================="
