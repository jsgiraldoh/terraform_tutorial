const http = require('http');
const hostname = 'localhost';
const port = 3000;

var MongoClient = require('mongodb').MongoClient;
var url = 'mongodb://35.86.135.155:27017/test';

const server = http.createServer((req, res) => {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/plain');
  res.end(`url: `+ url);	
	
  MongoClient.connect(url, function(err, db) {
    console.log(db);
  });	
});


server.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}/`);
});