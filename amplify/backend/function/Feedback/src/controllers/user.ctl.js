const connectToDatabase = require("/opt/mongoose.lib");

const feedback = async (req, res) => {
  const {
    models: { User },
  } = await connectToDatabase();

  User.create(req.body, (err, feedback) => {
    if (err) {
      console.log(err);
      res.status(400).send({ message: err.message });
    } else {
      res.status(200).send(feedback);
    }
  });
};

module.exports = feedback;
