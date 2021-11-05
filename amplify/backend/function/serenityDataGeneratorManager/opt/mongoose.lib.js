const mongoose = require("mongoose");
const stepSchema = require("./schemas/steps.schema");
const routineSchema = require("./schemas/routine.schema");
const userSchema = require("./schemas/user.schema");
mongoose.Promise = global.Promise;
let isConnected,
  corpusConn,
  userFeedbackConn,
  Step00,
  Step01,
  Step1,
  Step2,
  Step3,
  Step4,
  Step5,
  Step6,
  Step7;

module.exports = connectToDatabase = async () => {
  if (isConnected) {
    console.log("=> using existing database connection");
    return {
      conns: {
        corpusConn,
        userFeedbackConn,
      },
      models: {
        Step00,
        Step01,
        Step1,
        Step2,
        Step3,
        Step4,
        Step5,
        Step6,
        Step7,
        Feedback,
      },
    };
  }

  console.log("=> using new database connections");
  corpusConn = mongoose.createConnection(
    "mongodb+srv://admin:HDthdCvcq6tW65D@gradua.hbsqg.mongodb.net/corpus?retryWrites=true&w=majority"
  );
  userFeedbackConn = mongoose.createConnection(
    "mongodb+srv://admin:HDthdCvcq6tW65D@gradua.hbsqg.mongodb.net/user_feedback?retryWrites=true&w=majority"
  );
  Step00 = corpusConn.model("step00", stepSchema);
  Step01 = corpusConn.model("step01", stepSchema);
  Step1 = corpusConn.model("step1", stepSchema);
  Step2 = corpusConn.model("step2", stepSchema);
  Step3 = corpusConn.model("step3", stepSchema);
  Step4 = corpusConn.model("step4", stepSchema);
  Step5 = corpusConn.model("step5", stepSchema);
  Step6 = corpusConn.model("step6", stepSchema);
  Step7 = corpusConn.model("step7", stepSchema);
  User = userFeedbackConn.model("user", userSchema);
  Routine = userFeedbackConn.model("feedback", routineSchema);
  isConnected = true;
  return {
    conns: {
      corpusConn,
      userFeedbackConn,
    },
    models: {
      Step00,
      Step01,
      Step1,
      Step2,
      Step3,
      Step4,
      Step5,
      Step6,
      Step7,
      Routine,
      User,
    },
  };
};
