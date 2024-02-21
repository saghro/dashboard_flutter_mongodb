const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const courseSchema = new Schema({
    name: String,
    description: String,
    id: Number,
});

module.exports = mongoose.model('Course', courseSchema);