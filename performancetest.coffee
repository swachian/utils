pathToABigFile = '/usr/local/nginx/html/index.html';

fs = require('fs');

http = require('http');

longAssString = fs.readFileSync(pathToABigFile, 'utf8');
longAssBuffer = fs.readFileSync(pathToABigFile);

s = longAssString

# for i in [0..160]
  # s += longAssString

buffer = new Buffer(s);

server = http.createServer (req, res) -> 
  #console.log('STATUS: ' + res.url);
  if (req.url == '/buffer') 
    console.log('STATUS: ' + res.statusCode);
    setTimeout ->
      res.writeHead(200)
      res.end(buffer)
    , 1
  
  else if (req.url == '/favicon.ico') 
    # don't serve it double
    res.writeHead(404);
    res.end('Not found');
  
  else 
    res.end(s);
  


server.listen(1234)