http = require('http')

# 同步调用
s = http.createServer (request, response) -> 
  response.writeHead(200, {'Content-Type': 'text/plain'})
  response.end('Hello World\n')
  console.log " #{new Date()} a request" 
  
s.listen(8124)

# 链式调用
http.createServer (request, response) -> 
  response.writeHead(200, {'Content-Type': 'text/plain'})
  response.end('Hello World\n')
  console.log " #{new Date()} a request" 
.listen(8125)

# Wrong. .listen会绑给console.log
http.createServer (request, response) -> 
  response.writeHead(200, {'Content-Type': 'text/plain'})
  response.end('Hello World\n')
  console.log " #{new Date()} a request" 
  .listen(8126)
