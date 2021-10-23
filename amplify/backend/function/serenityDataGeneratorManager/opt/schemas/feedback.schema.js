
const mongoose = require('mongoose');
const routineSchema = new mongoose.Schema({
    "step00": [{ type: mongoose.Schema.Types.ObjectId, ref: 'step00' }],
    "step01": [{ type: mongoose.Schema.Types.ObjectId, ref: 'step01' }],
    "step1": [{ type: mongoose.Schema.Types.ObjectId, ref: 'step1' }],
    "step2": [{ type: mongoose.Schema.Types.ObjectId, ref: 'step2' }],
    "step3": [{ type: mongoose.Schema.Types.ObjectId, ref: 'step3' }],
    "step4": [{ type: mongoose.Schema.Types.ObjectId, ref: 'step4' }],
    "step5": [{ type: mongoose.Schema.Types.ObjectId, ref: 'step5' }],
    "step6": [{ type: mongoose.Schema.Types.ObjectId, ref: 'step6' }],
    "step7": [{ type: mongoose.Schema.Types.ObjectId, ref: 'step7' }],
});

module.exports =  feedbackSchema = new mongoose.Schema({
    score: Number,
    stateBefore: Number,
    stateAfter: Number,
    objectiveType: String,
    routine: routineSchema,
});