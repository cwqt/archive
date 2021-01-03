import express          from "express"
import morgan           from "morgan"
import 'dotenv/config';

import routes           from "./routes"
import db               from "./db"

const app = express();

(async () => {
  await db.init()
  app.set('trust proxy', 1);
  app.use(morgan("tiny"))
  app.use(express.json());
  app.listen(3000, () => {
    console.log('Listening on 3000')
  })
  
  app.use(function(req, res, next) {
    res.header("Access-Control-Allow-Origin", "http://localhost:4200"); // update to match the domain you will make the request from
    res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
    next();
  });

  app.use("/plants",       routes.plants)
  app.use("/plants/:_id",  routes.plant)
})();
