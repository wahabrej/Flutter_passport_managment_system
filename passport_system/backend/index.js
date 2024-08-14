const express = require('express');
const app = express();
const port = process.env.PORT || 8080;
const cors = require('cors');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');
const session = require('express-session');
const MongoStore = require('connect-mongo');

// MongoDB connection
mongoose.connect("mongodb+srv://wahabreja:reja32103434@cluster0.gkjjdd3.mongodb.net/crud", {
  useNewUrlParser: true,
  useUnifiedTopology: true
})
.then(() => console.log('MongoDB connected successfully'))
.catch(err => console.error('MongoDB connection error:', err));

// Middleware
app.use(cors());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

// Session setup
app.use(session({
  secret: 'your_secret_key', // Replace with a strong secret key
  resave: false,
  saveUninitialized: false,
  store: MongoStore.create({ mongoUrl: "mongodb+srv://wahabreja:reja32103434@cluster0.gkjjdd3.mongodb.net/crud" }),
  cookie: { maxAge: 1000 * 60 * 60 * 24 } // 1 day
}));

// Routes
app.use('/', require('./routes/user.route'));
app.use('/', require('./routes/application.route'));

// Server listening
app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
