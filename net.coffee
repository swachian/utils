# createServer的例子
net = require 'net'
server = net.createServer (c) -> # c是一个socket
  console.log('server connected')
  c.on 'end', -> console.log('server disconnected') 
  c.write 'hello\r\n'
  c.on 'data', (data)-> c.write(data) #等价于下面的pipe()
  #c.pipe(c)
  c.on 'err', (err) -> 
    console.log(err)
    c.write(err)
  c.on 'close', -> console.log('client closed')
#server.listen 8124, -> console.log('server bound')
#server.listen 8125, -> console.log('server bound 8125')
server.listen '/tmp/echo.sock', -> console.log('server bound unix ')