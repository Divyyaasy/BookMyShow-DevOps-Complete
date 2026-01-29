const express = require('express');
const app = express();
const PORT = process.env.PORT || 3002;

app.use(express.json());

// Sample movie data
const movies = [
  { id: 1, title: 'Avengers: Endgame', genre: 'Action', duration: '3h 2m', rating: 8.4 },
  { id: 2, title: 'The Shawshank Redemption', genre: 'Drama', duration: '2h 22m', rating: 9.3 },
  { id: 3, title: 'The Dark Knight', genre: 'Action', duration: '2h 32m', rating: 9.0 },
  { id: 4, title: 'Inception', genre: 'Sci-Fi', duration: '2h 28m', rating: 8.8 },
  { id: 5, title: 'Parasite', genre: 'Thriller', duration: '2h 12m', rating: 8.6 }
];

// Health endpoint
app.get('/api/health', (req, res) => {
  res.json({ 
    status: 'healthy',
    service: 'movie-service',
    timestamp: new Date().toISOString()
  });
});

// Get all movies
app.get('/api/movies', (req, res) => {
  res.json({ movies });
});

// Get movie by ID
app.get('/api/movies/:id', (req, res) => {
  const movie = movies.find(m => m.id === parseInt(req.params.id));
  if (movie) {
    res.json(movie);
  } else {
    res.status(404).json({ error: 'Movie not found' });
  }
});

// Search movies
app.get('/api/movies/search/:query', (req, res) => {
  const query = req.params.query.toLowerCase();
  const results = movies.filter(movie => 
    movie.title.toLowerCase().includes(query) || 
    movie.genre.toLowerCase().includes(query)
  );
  res.json({ results });
});

app.listen(PORT, () => {
  console.log(`Movie Service running on port ${PORT}`);
});
