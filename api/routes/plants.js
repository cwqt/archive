import { Router } from 'express';
import { ObjectId } from "mongodb"
import db         from "../db";

const router = Router();

router.get('/',  (req, res) => {
  db.getDb().collection("plants")
    .find({})
    .limit(10)
    .toArray(function(err, result) {
      if (err) console.log(err);
      return res.json(result)
    });
})

router.post("/", (req, res) => {
  var body = req.body
  body["_id"] = ObjectId()
  body["created_at"] = Math.round((new Date()).getTime() / 1000);
  body["type"] = "plant"
  body["recording"] = []

  db.getDb().collection("plants")
    .insertOne(body, (err, result) => {
      if (err) return res.status(400).end();
      return res.status(201).send(body)
    })
})

export default router;
