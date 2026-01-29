const express = require('express');
const app = express();
const PORT = process.env.PORT || 3001;

app.use(express.json());

// In-memory user database (replace with MongoDB in production)
let users = [
  { id: 1, email: 'user1@example.com', name: 'John Doe' },
  { id: 2, email: 'user2@example.com', name: 'Jane Smith' }
];

// Health endpoint
app.get('/api/health', (req, res) => {
  res.json({ 
    status: 'healthy',
    service: 'user-service',
    timestamp: new Date().toISOString()
  });
});

// Get all users
app.get('/api/users', (req, res) => {
  res.json({ users });
});

// Get user by ID
app.get('/api/users/:id', (req, res) => {
  const user = users.find(u => u.id === parseInt(req.params.id));
  if (user) {
    res.json(user);
  } else {
    res.status(404).json({ error: 'User not found' });
  }
});

// Create user
app.post('/api/users', (req, res) => {
  const newUser = {
    id: users.length + 1,
    email: req.body.email,
    name: req.body.name
  };
  users.push(newUser);
  res.status(201).json(newUser);
});

app.listen(PORT, () => {
  console.log(`User Service running on port ${PORT}`);
});
