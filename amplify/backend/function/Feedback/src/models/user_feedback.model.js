
const mongoose = require('mongoose');
const routineSchema = new mongoose.Schema({
    "step00": [String],
    "step01": [String],
    "step1": [String],
    "step2": [String],
    "step3": [String],
    "step4": [String],
    "step5": [String],
    "step6": [String],
    "step7": [String],
});

const feedbackSchema = new mongoose.Schema({
    score: Number,
    stateBefore: Number,
    stateAfter: Number,
    objectiveType: String,
    routine: routineSchema,
});


module.exports = mongoose.model('user_feedback', feedbackSchema)