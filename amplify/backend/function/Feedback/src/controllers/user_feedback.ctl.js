const connectToDatabase = require('../libs/mongoose.lib');
const UserFeedback = require('../models/user_feedback.model');

const user_feedback = async (req, res) =>{
    connectToDatabase()
    .then(async () => {
        UserFeedback.create(req.body, (err, feedback) => {
            if (err) {
                console.log(err);
                res.status(400).send({message:err.message});        
            } else {
                res.status(200).send(feedback);
            }
        })       
    }).catch(err=>{
        console.log(err);
        res.status(500).send({message:err.message});
    });
}

module.exports = user_feedback;