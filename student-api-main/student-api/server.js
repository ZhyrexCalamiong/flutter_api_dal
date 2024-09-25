const express = require('express');
const mysql = require('mysql');
const bodyParser = require('body-parser');
const cors = require('cors');
const fs = require('fs'); // Added fs module

const app = express();
app.use(bodyParser.json());
app.use(cors());

const PORT = 3000; // Added PORT variable

// MySQL connection setup
const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'studentdb'
});

// Connect to MySQL
db.connect((err) => {
  if (err) {
    console.error('Error connecting to MySQL:', err);
    return;
  }
  console.log('MySQL Connected...');
});

// Create 'students' table if not exists
const createTable = `
  CREATE TABLE IF NOT EXISTS students (
      id INT AUTO_INCREMENT PRIMARY KEY,
      firstName VARCHAR(255) NOT NULL,
      lastName VARCHAR(255) NOT NULL,
      course VARCHAR(255) NOT NULL,
      year VARCHAR(255) NOT NULL,
      enrolled BOOLEAN NOT NULL
  )
`;

// Get all students
app.get('/api/students', (req, res) => {
  const query = 'SELECT * FROM students';
  db.query(query, (err, results) => {
    if (err) throw err;
    res.json(results);
  });
});

// Add a new student
app.post('/api/students', (req, res) => {
  const { firstName, lastName, course, year, enrolled } = req.body;
  const query = 'INSERT INTO students (firstName, lastName, course, year, enrolled) VALUES (?, ?, ?, ?, ?)';
  db.query(query, [firstName, lastName, course, year, enrolled], (err, result) => {
    if (err) throw err;
    res.status(201).json({ id: result.insertId, ...req.body });
  });
});

// Update a student by ID
app.put('/api/students/:id', (req, res) => {
  const { id } = req.params;
  const { firstName, lastName, course, year, enrolled } = req.body;
  const query = 'UPDATE students SET firstName = ?, lastName = ?, course = ?, year = ?, enrolled = ? WHERE id = ?';
  db.query(query, [firstName, lastName, course, year, enrolled, id], (err) => {
    if (err) throw err;
    res.json({ id, ...req.body });
  });
});

// Delete a student by ID
app.delete('/api/students/:id', (req, res) => {
  const { id } = req.params;
  const query = 'DELETE FROM students WHERE id = ?';
  db.query(query, [id], (err, result) => {
    if (err) throw err;
    res.json({ message: `Student with ID ${id} deleted.` });
  });
});

// Start the server
app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
