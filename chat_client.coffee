io = require 'socket.io-client'
net = require 'net'
readline = require 'readline'

socket = io.connect("http://127.0.0.1:8000")
# socket = new net.Socket()
# socket.connect(8000)
socket.emit('broadcast', "I love nodejs")

socket.on 'message', (message) ->
  console.log message

socket.on 'connect', ->
  console.log 'Connected'
  
rl = readline.createInterface(process.stdin, process.stdout)

rl.on 'line', (msg) ->
  socket.emit('broadcast', msg)
.on 'close', ->
  process.exit(0)
