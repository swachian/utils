// Generated by CoffeeScript 1.3.3
(function() {
  var buffer, fs, http, i, longAssBuffer, longAssString, pathToABigFile, s, server, _i;

  pathToABigFile = '/usr/local/nginx/html/index.html';

  fs = require('fs');

  http = require('http');

  longAssString = fs.readFileSync(pathToABigFile, 'utf8');

  longAssBuffer = fs.readFileSync(pathToABigFile);

  s = longAssString;

  for (i = _i = 0; _i <= 160; i = ++_i) {
    s += longAssString;
  }

  buffer = new Buffer(s);

  server = http.createServer(function(req, res) {
    if (req.url === '/buffer') {
      return setTimeout(function() {
        res.writeHead(200);
        return res.end(buffer);
      }, 1000);
    } else if (req.url === '/favicon.ico') {
      res.writeHead(404);
      return res.end('Not found');
    } else {
      return res.end(s);
    }
  });

  server.listen(1337);

}).call(this);
