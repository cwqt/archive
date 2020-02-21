import { Router } from 'express';
import db         from "../db";
import { ObjectID } from "mongodb"

const router = Router({mergeParams: true});

router.get('/', async (req, res) => {
    db.getDb().collection("plants")
    .findOne({_id: ObjectID(req.params._id)})
    .then(doc => {
      console.log(doc);
      return res.json(doc)
    });
})

router.delete('/', (req, res) => {
  
})

export default router;
