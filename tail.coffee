fs = require "fs"

class Tail
  poll: ->
    buffer = new Buffer(8192)
    fs.open process.argv[2], 'r',  (err, fd) ->
      while true
        s = fs.readSync(fd, buffer, 0, buffer.length)
        if s > 0 then console.log buffer.toString('utf8', 0, s-1) 
  
  watch: ->
    buffer = new Buffer(8192)
    fd = fs.openSync process.argv[2], 'r'
    s = fs.readSync(fd, buffer, 0, buffer.length)
    console.log buffer.toString('utf8', 0, s-1) 
    fs.watch process.argv[2], {persistent: true}, (event, filename) ->
      s = fs.readSync(fd, buffer, 0, buffer.length)
      console.log buffer.toString('utf8', 0, s-1) 
      

tail = new Tail()
tail.watch()
