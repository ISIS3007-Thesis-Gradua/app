const express = require('express');
const user_feedback = require('../controllers/user_feedback.ctl');
const router = new express.Router();
/*
 * get all estudiantes in the system
 */
router.post('/', user_feedback);

module.exports = router;
