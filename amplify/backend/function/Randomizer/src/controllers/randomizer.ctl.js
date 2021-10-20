const connectToDatabase = require('../libs/mongoose.lib');
const {
    Step00,
    Step01,
    Step1,
    Step2,
    Step3,
    Step4,
    Step5,
    Step6,
    Step7,
} = require('../models/steps.model');

const randomize = async (req, res) =>{
    connectToDatabase()
    .then(async () => {
        try {
            const result = [
                await Step00.aggregate([{ $sample: { size: 1 } }]),
                await Step01.aggregate([{ $sample: { size: 1 } }]),
                await Step1.aggregate([{ $sample: { size: 1 } }]),
                await Step2.aggregate([{ $sample: { size: 1 } }]),
                await Step3.aggregate([{ $sample: { size: 1 } }]),
                await Step4.aggregate([{ $sample: { size: 1 } }]),
                await Step5.aggregate([{ $sample: { size: 1 } }]),
                await Step6.aggregate([{ $sample: { size: 1 } }]),
                await Step7.aggregate([{ $sample: { size: 1 } }]),
            ]
            res.status(200).send(JSON.stringify(result));
        } catch(err){
            console.log(err)
            res.status(404).send({message:err.message});
        }            
    }).catch(err=>console.log(err));
}

module.exports = randomize;