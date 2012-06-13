puts = console.log

# setInterval( -> 
  # console.log('in')
# , 2000)
# 
# setTimeout -> 
  # puts "time out"
# , 20000
# 
# puts "Hello"

filename = process.argv[2]
crypto = require 'crypto'
fs = require 'fs'

shasum = crypto.createHash('sha1')

s = fs.createReadStream(filename)


s.on 'data', (d) -> 
  shasum.update(d)
#  puts d.toString()

s.on 'open', (fd) ->
  puts fd
  
s.on 'end', -> 
  d = shasum.digest('hex')
  puts d + ' ' + filename


# util = require 'util'
# fs.stat process.argv[2], (err, stats) ->
  # puts util.inspect(stats)   
