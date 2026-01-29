const express = require('express');
const { createProxyMiddleware } = require('http-proxy-middleware');
const app = express();
const PORT = process.env.PORT || 3000;

// Health check endpoint
app.get('/api/health', (req, res) => {
  res.json({
    status: 'healthy',
    service: 'api-gateway',
    timestamp: new Date().toISOString(),
    services: {
      user: 'http://user-service:3001',
      movie: 'http://movie-service:3002',
      booking: 'http://booking-service:3003',
      payment: 'http://payment-service:3004'
    }
  });
});

// Proxy middleware configuration
const services = {
  '/api/users': 'http://user-service:3001',
  '/api/movies': 'http://movie-service:3002',
  '/api/bookings': 'http://booking-service:3003',
  '/api/payments': 'http://payment-service:3004'
};

// Set up proxies for each service
Object.entries(services).forEach(([path, target]) => {
  app.use(path, createProxyMiddleware({
    target,
    changeOrigin: true,
    pathRewrite: {
      [`^${path}`]: path
    }
  }));
});

// Root endpoint
app.get('/', (req, res) => {
  res.json({
    message: 'Welcome to BookMyShow Microservices API',
    version: '1.0.0',
    endpoints: [
      '/api/users - User management',
      '/api/movies - Movie catalog',
      '/api/bookings - Booking management',
      '/api/payments - Payment processing',
      '/api/health - System health'
    ]
  });
});

app.listen(PORT, () => {
  console.log(`API Gateway running on port ${PORT}`);
});
