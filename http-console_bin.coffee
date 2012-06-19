util = require 'util'
print = util.print
puts = util.puts

help = [
  'usage: http-console [username:password@host:port] [options]',
  '',
  'options:',
  '    --cookies      remember cookies',
  '-v, --verbose      print requests',
  '    --json         set "Content-Type" header to application/json',
  '    --notimeout    don\'t timeout requests',
  '    --ssl          create a secure connection',
  '    --version      print version',
  '-h, --help         display this message'
].join("\n")

options =  
  rememberCookies: true
  useSSL:          "protocol == 'https'"
  json:            false
  timeout:         true
  verbose:         false
   

argv = process.argv.slice(2)

puts argv
args = []

for arg in argv
  if (matches = arg.match(/^--?([\w-]+)$/))
    option= matches[1]
    switch option
      when 'cookies' then options.rememberCookies = true
      when 'non-cookies' then options.rememberCookies = false
      when 'h', 'help'
        puts help
        process.exit(0)
      else
        puts("http-console: unrecognized option '" + matches[0] + "'")
    
puts util.inspect(options)
