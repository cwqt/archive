import { MongoClient } 	from "mongodb"

var _db;

module.exports = {
  init: function() {
    return new Promise((resolve, reject) => {
      MongoClient.connect(process.env.MONGO_URL, { useNewUrlParser: true, useUnifiedTopology: true }, function( err, client ) {
        if (err) return console.log(err);
        console.log("Connected to MongoDB")
        _db  = client.db("test");
        resolve();
      });
    })
  },

  close: function() {
    _db.close();
  },

  getDb: function() {
    return _db;
  },
};
