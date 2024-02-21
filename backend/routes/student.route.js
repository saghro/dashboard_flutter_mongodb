const express = require('express');
const router = express.Router();
const Student = require('../models/student.model');

router.post('/', async (req, res) => {
    try {
        const studentCount = await Student.countDocuments();
        const newStudent = new Student({
            name: req.body.name,
            email: req.body.email,
            id:studentCount+1
        });
        const savedStudent = await newStudent.save();
        res.json(savedStudent);
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Internal server error' });
    }
});

router.get('/', async (req, res) => {
    try {
        const students = await Student.find();
        res.json(students);
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Internal server error' });
    }
});

router.delete('/', async (req, res) => {
    try {
        const idsToDelete = req.body.ids;
        const deletedStudents = await Student.deleteMany({ _id: { $in: idsToDelete } });

        if (!deletedStudents) {
            return res.status(404).json({ message: 'Students not found' });
        }

        res.json({ message: 'Students deleted successfully' });
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: 'Internal server error' });
    }
});

module.exports = router;
