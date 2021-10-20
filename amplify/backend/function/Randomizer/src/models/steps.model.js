
const mongoose = require('mongoose');
const schema = new mongoose.Schema({
    rawContent: String,
    content: String,
    rawSize: Number,
});

exports.Step00 = mongoose.model('step00', schema)
exports.Step01 = mongoose.model('step01', schema)
exports.Step1 = mongoose.model('step1', schema)
exports.Step2 = mongoose.model('step2', schema)
exports.Step3 = mongoose.model('step3', schema)
exports.Step4 = mongoose.model('step4', schema)
exports.Step5 = mongoose.model('step5', schema)
exports.Step6 = mongoose.model('step6', schema)
exports.Step7 = mongoose.model('step7', schema)