http = require 'http'
io = require 'socket.io'
redis = require 'redis'
#rc = redis.createClient()

server = http.createServer (req, res) ->
  res.writeHead(200, {'Content-Type': 'text/html'})
  res.end(('<h1>Hello world</h1>'))
  
server.listen 8000

io = io.listen server
io.sockets.on 'connection', (socket) ->
  clientId = socket.id
  
  socket.on 'disconnect', (message) ->
    console.log 'disconnect'
  
  socket.on 'publish', (message) ->
    console.log 'publish'
    socket.emit 'broadcast', message 
    
  socket.on 'broadcast', (message) ->
    socket.broadcast.send(message)
    
  socket.on 'addUser', (message) ->
    socket.broadcast.emit 'newUser', 'aaa'


# rc.on "connect", ->
  # console.log "connected to chat"
  # rc.subscribe("chat")
#   
# 
# rc.on "message", (channel, message) ->
  # console.log("Sending:" + message)
  # socketio.sockets.emit('message', message)

