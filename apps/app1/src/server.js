const express = require('express');
const app = express();
const PORT = process.env.PORT || 8080;

// Middleware básico
app.use(express.json());

// Ruta principal
app.get('/', (req, res) => {
  res.json({
    message: 'API Service funcionando',
    timestamp: new Date().toISOString()
  });
});

// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'UP' });
});

// Endpoint de ejemplo
app.get('/api/data', (req, res) => {
  res.json({
    data: [
      { id: 1, name: 'Item 1' },
      { id: 2, name: 'Item 2' },
      { id: 3, name: 'Item 3' }
    ]
  });
});

// Iniciar servidor
app.listen(PORT, () => {
  console.log(`API Service corriendo en puerto ${PORT}`);
});