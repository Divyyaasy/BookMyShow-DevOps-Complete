const express = require('express');
const app = express();
const PORT = process.env.PORT || 3003;

app.use(express.json());

// Sample bookings data
let bookings = [
  { id: 1, userId: 1, movieId: 1, seats: ['A1', 'A2'], showTime: '2024-01-30T18:00:00', totalPrice: 500 },
  { id: 2, userId: 2, movieId: 3, seats: ['B3', 'B4'], showTime: '2024-01-30T21:00:00', totalPrice: 600 }
];

// Health endpoint
app.get('/api/health', (req, res) => {
  res.json({ 
    status: 'healthy',
    service: 'booking-service',
    timestamp: new Date().toISOString()
  });
});

// Get all bookings
app.get('/api/bookings', (req, res) => {
  res.json({ bookings });
});

// Get booking by ID
app.get('/api/bookings/:id', (req, res) => {
  const booking = bookings.find(b => b.id === parseInt(req.params.id));
  if (booking) {
    res.json(booking);
  } else {
    res.status(404).json({ error: 'Booking not found' });
  }
});

// Create booking
app.post('/api/bookings', (req, res) => {
  const newBooking = {
    id: bookings.length + 1,
    userId: req.body.userId,
    movieId: req.body.movieId,
    seats: req.body.seats,
    showTime: req.body.showTime,
    totalPrice: req.body.totalPrice,
    status: 'confirmed',
    createdAt: new Date().toISOString()
  };
  bookings.push(newBooking);
  res.status(201).json(newBooking);
});

// Cancel booking
app.put('/api/bookings/:id/cancel', (req, res) => {
  const booking = bookings.find(b => b.id === parseInt(req.params.id));
  if (booking) {
    booking.status = 'cancelled';
    res.json(booking);
  } else {
    res.status(404).json({ error: 'Booking not found' });
  }
});

app.listen(PORT, () => {
  console.log(`Booking Service running on port ${PORT}`);
});
