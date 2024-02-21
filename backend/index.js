const express = require("express");
const app = express();
const port = process.env.PORT || 8080;
const cors = require('cors');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');

// Connexion à MongoDB
mongoose.connect("mongodb+srv://ayoubsaghro22222:qLc9ewlsdyEcHABS@cluster0.do6vgbt.mongodb.net/",
    { useNewUrlParser: true, useUnifiedTopology: true });

// Middleware
app.use(cors());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

// Routes
const userRoutes = require('./routes/user.route');
const courseRoutes = require('./routes/course.route');
const studentRoutes = require('./routes/student.route'); 

// Utilisez les routes d'authentification
app.use('/', userRoutes);

// Utilisez les routes pour les cours
app.use('/api/courses', courseRoutes);

// Utilisez les routes pour les étudiants
app.use('/api/students', studentRoutes); 

// Lancement du serveur
app.listen(port, () => {
    console.log("Port running on " + port);
});
