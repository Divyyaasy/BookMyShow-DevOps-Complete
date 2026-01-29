const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

app.get('/', (req, res) => {
  res.json({
    message: 'Welcome to BookMyShow API!',
    status: 'success',
    timestamp: new Date().toISOString(),
    endpoints: ['/api/movies', '/api/theaters', '/api/bookings', '/api/health']
  });
});

app.get('/api/movies', (req, res) => {
  res.json({
    movies: [
      { id: 1, title: 'Movie 1', genre: 'Action' },
      { id: 2, title: 'Movie 2', genre: 'Drama' },
      { id: 3, title: 'Movie 3', genre: 'Comedy' }
    ]
  });
});

app.get('/api/health', (req, res) => {
  res.json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    service: 'bookmyshow-api'
  });
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
