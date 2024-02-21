const express = require('express');
const router = express.Router();
const Course = require('../models/course.model'); 

router.post('/', async (req, res) => {
    try {
        const coursesCount = await Course.countDocuments();
        const newCourse = new Course({
            name: req.body.name,
            description: req.body.description,
            id:coursesCount+1
            
        });
        const savedCourse = await newCourse.save();
        // Retournez l'ID généré par MongoDB
        res.json(savedCourse);
    } catch (err) {
        console.log(err);
        res.status(500).json(err);
    }
});


router.get('/', async (req, res) => {
    try {
        const courses = await Course.find();
        res.json(courses);
    } catch (err) {
        console.log(err);
        res.status(500).json(err);
    }
});

router.put('/:id', async (req, res) => {
    try {
        const updatedCourse = await Course.findByIdAndUpdate(req.params.id, {
            name: req.body.name,
            description: req.body.description
        }, { new: true });

        if (!updatedCourse) {
            return res.status(404).json({ message: 'Course not found' });
        }

        res.json(updatedCourse);
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Internal server error' });
    }
});


router.delete('/:id', async (req, res) => {
    try {
        const deletedCourse = await Course.findByIdAndDelete(req.params.id);
        if (!deletedCourse) {
            return res.status(404).json({ message: 'Course not found' });
        }
        res.json({ message: 'Course deleted successfully' });
        
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: err });
    }
});


module.exports = router;