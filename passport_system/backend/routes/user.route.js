const express = require('express');
const bcrypt = require('bcrypt');
const User = require('../models/user.model');
const router = express.Router();

router.post('/signup', async (req, res) => {
    try {
        const existingUser = await User.findOne({ email: req.body.email });
        if (existingUser) {
            return res.status(409).json({ message: 'Email is already in use' });
        }

        const newUser = new User({
            firstName: req.body.firstName,
            lastName: req.body.lastName,
            dob: req.body.dob,
            phone: req.body.phone,
            nid: req.body.nid,
            email: req.body.email,
            password: req.body.password,
            role: req.body.role
        });

        const savedUser = await newUser.save();
        res.status(201).json(savedUser);
    } catch (err) {
        console.log(err);
        res.status(500).json({ error: 'Internal Server Error' });
    }
});

router.post('/signin', async (req, res) => {
    try {
        const user = await User.findOne({ email: req.body.email });
        if (!user) {
            return res.status(404).json({ message: 'User not found' });
        }

        if (user.password !== req.body.password) {
            return res.status(401).json({ message: 'Invalid password' });
        }

        // Set session data
        req.session.user = {
            id: user._id,
            email: user.email,
            role: user.role
        };

        res.status(200).json({ message: 'Login successful', user: req.session.user });
    } catch (err) {
        console.log(err);
        res.status(500).json({ error: 'Internal Server Error' });
    }
});

router.get('/getUser/:id', (req, res) => {
    const userId = req.params.id;
    User.findById(userId, (err, user) => {
        if (err) {
            console.log(err);
            return res.status(500).json({ error: 'Internal Server Error' });
        }
        if (!user) {
            return res.status(404).json({ message: 'User not found' });
        }
        res.status(200).json(user);
    });
});

router.get('/logout', (req, res) => {
    // Destroy the session
    req.session.destroy(err => {
        if (err) {
            return res.status(500).json({ error: 'Failed to logout' });
        }
        res.clearCookie('connect.sid'); // Optional: clear the session cookie
        res.status(200).json({ message: 'Logout successful' });
    });
});

module.exports = router;
