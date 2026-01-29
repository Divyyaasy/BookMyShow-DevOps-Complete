const express = require('express');
const app = express();
const PORT = process.env.PORT || 3004;

app.use(express.json());

// Sample payments data
let payments = [
  { id: 1, bookingId: 1, amount: 500, status: 'completed', paymentMethod: 'credit_card' },
  { id: 2, bookingId: 2, amount: 600, status: 'completed', paymentMethod: 'upi' }
];

// Health endpoint
app.get('/api/health', (req, res) => {
  res.json({ 
    status: 'healthy',
    service: 'payment-service',
    timestamp: new Date().toISOString()
  });
});

// Process payment
app.post('/api/payments/process', (req, res) => {
  const { bookingId, amount, paymentMethod } = req.body;
  
  // Simulate payment processing
  const newPayment = {
    id: payments.length + 1,
    bookingId,
    amount,
    paymentMethod,
    status: 'completed',
    transactionId: 'TXN' + Date.now(),
    processedAt: new Date().toISOString()
  };
  
  payments.push(newPayment);
  res.status(201).json(newPayment);
});

// Get payment by ID
app.get('/api/payments/:id', (req, res) => {
  const payment = payments.find(p => p.id === parseInt(req.params.id));
  if (payment) {
    res.json(payment);
  } else {
    res.status(404).json({ error: 'Payment not found' });
  }
});

// Get payments by booking ID
app.get('/api/payments/booking/:bookingId', (req, res) => {
  const bookingPayments = payments.filter(p => p.bookingId === parseInt(req.params.bookingId));
  res.json({ payments: bookingPayments });
});

app.listen(PORT, () => {
  console.log(`Payment Service running on port ${PORT}`);
});
