import { Router } from 'express';
import { ObjectId } from "mongodb"
import db         from "../db";

const router = Router();

router.get('/',  (req, res) => {
  var page = req.query.page ? parseInt(req.query.page) : 1;
  var per_page = req.query.per_page ? parseInt(req.query.per_page) : 5;
  const _db = db.getDb();

  var query = {}
  if (req.query.name) {
    query["name"] = req.query.name
  }

  _db.collection("plants").countDocuments(query, (err, count) => {
    if (err) { return res.status(400) }

    console.log(count)

    _db.collection("plants")
      .find(query)
      .skip((page-1) * per_page)
      .limit(per_page)
      .toArray(function(err, result) {
        if (err) { return res.status(400) }
        console.log(result)
        var _data = {
          data: result,
          first: req.baseUrl + `?page=1&per_page=${per_page}`,
          last: req.baseUrl + `?page=${Math.ceil(count/per_page)}&per_page=${per_page}`,
          page_count: Math.ceil(count/per_page)
        }
        if ((page-1)*per_page > 0) {
          _data["prev"] = req.baseUrl + `?page=${page-1}&per_page=${per_page}`
        }
        if (page*per_page < count) {
          _data["next"] = req.baseUrl + `?page=${page+1}&per_page=${per_page}`
        }
        return res.json(_data)
      });
  })
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
