
const mongoose = require('mongoose');
const feedbackSchema = new mongoose.Schema({
    moodBefore: Number,
    moodAfter: Number,
    anxietyBefore: Number,
    anxietyAfter: Number,
    stressBefore: Number,
    stressAfter: Number,
    score: Number,
});

module.exports =   routineSchema = new mongoose.Schema({
    owner: { type: mongoose.Schema.Types.ObjectId, ref: 'user' },
    feedback: feedbackSchema,
    step00: [{ type: mongoose.Schema.Types.ObjectId, ref: 'step00' }],
    step01: [{ type: mongoose.Schema.Types.ObjectId, ref: 'step01' }],
    step1: [{ type: mongoose.Schema.Types.ObjectId, ref: 'step1' }],
    step2: [{ type: mongoose.Schema.Types.ObjectId, ref: 'step2' }],
    step3: [{ type: mongoose.Schema.Types.ObjectId, ref: 'step3' }],
    step4: [{ type: mongoose.Schema.Types.ObjectId, ref: 'step4' }],
    step5: [{ type: mongoose.Schema.Types.ObjectId, ref: 'step5' }],
    step6: [{ type: mongoose.Schema.Types.ObjectId, ref: 'step6' }],
    step7: [{ type: mongoose.Schema.Types.ObjectId, ref: 'step7' }],
});