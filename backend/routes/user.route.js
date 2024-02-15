const express = require('express');
const router = express.Router();
const User = require('../models/user.model');

router.post('/signup', async (req, res) => {
    try {
        const existingUser = await User.findOne({ email: req.body.email });
        if (existingUser) {
            return res.json({ message: 'Email is not available' });
        } else {
            const newUser = new User({
                email: req.body.email,
                password: req.body.password,
                fullName: req.body.fullName // Récupération du fullName depuis la requête
            });
            const savedUser = await newUser.save();
            res.json(savedUser);
        }
    } catch (err) {
        console.log(err);
        res.status(500).json(err);
    }
});

router.post('/signin', async (req, res) => {
    try {
        const user = await User.findOne({ email: req.body.email, password: req.body.password });
        if (!user) {
            return res.status(404).json({ message: 'User not found' });
        }
        res.json(user);
    } catch (err) {
        console.log(err);
        res.status(500).json(err);
    }
});

module.exports = router;
