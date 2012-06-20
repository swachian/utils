# 引入util, colors, http, https, fs, events, querystring, readline, utils 
# alias print / puts
util = require 'util'
colors = require 'colors'
http = require 'http'
https = require 'https'
fs= require 'fs'
events = require 'events'
querystring = require 'querystring'
readline = require 'readline'
print = util.print
puts = util.puts
inspect = require('eyes').inspector()


# 定义hep字符串，用数字join的方式
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

#定义options
options =  
  rememberCookies: true
  useSSL:          "protocol == 'https'"
  json:            false
  timeout:         true
  verbose:         false
   
# 分析argv，只要前两位之后的
argv = process.argv.slice(2)
args = []

# 对于-或者--开头的进行处理及options的设置，非此开头的，追写到 args
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
   else
     args.push(arg)

# puts util.inspect(options)

# 根据args的内容分析url，最终要解析出protocol, hostport, auth, host, port这些信息
# 如存在auth的话，则把username，password存放到options的auth中
# 注意`split`, `shift`,`pop`的交替使用
# 注意?在正则括号最外面的**妙用**
url = args.shift() || "http://n:p@127.0.0.1:8080"
protocol = url.match(/^(https?)?/)[0] || 'http'

url = url.replace(protocol+'://', '').split("@")

hostport = url.pop().split(":")
auth = url.pop()

host = hostport.shift()
port = hostport.shift() || 80

if (auth)
  auth = auth.split(":")
  options.auth = 
    username: auth.shift()
    password: auth.shift()
puts  hostport, auth, host, port
inspect(options.auth)

### 编写console
###
consoles = []

class Console
  ### 构造函数
    host - 
    port -
    options - 输入的一些关于cookie、session等的选项
  ### 
  constructor: (host, port, options) ->
    @host = host
    @port = parseInt(port)
    @options = options
    @timeout = if @options.timeout then 5000 else 0
    @path = []
    @socket = null
    @cookies = {}
    consoles.push(this)
    
  ### 初始函数     建立console实例后即刻调用
  Example:
     console = new(httpConsole.Console)(host, port, options);
     console.initialize()
   返回 对象本身 this
  ###
  initialize: ->
    @welcome()
    
    @headers = { 'Accept': '*/*'}
    
    if @options.auth
      @headers['Authorization'] = "Basic " +
        new(Buffer)(@options.auth.username + ':' + @options.auth.password).toString('base64')

    @readline = readline.createInterface(process.stdin, process.stdout)
    @readline.on 'line', (cmd) =>
      @exec(cmd.trim())
    .on 'close', ->
      process.stdout.write("\n")
      process.exit(0)
      
    @prompt()
    
    http.globalAgent.maxSockets = 2000
    
    this
  
  ### welcome 欢迎致辞函数
  ###
  welcome: ->
    puts("> " + ("http-console " + '1.0').bold,
                 "> Welcome, enter .help if you're lost.",
                 "> Connecting to " + @host + " on port " + @port + '.');
    puts()
    
  ### 发起请求
  method - the string of http access method
  path - the string of path
  headers - the hash 
  callback - 呼叫函数，代码块
   返回 request
  ###
  request: (method, path, headers, callback)=>
    @headers['Host'] = this.host
    
    for k in @headers 
      headers[k] = @headers[k]
      
    method = method.toUpperCase()
    path = encodeURI(path)
    
    @setCookies(headers)
    
    request = (if this.options.useSSL then https else http).request {
      host: @host,
      port: @port,
      method: method,
      path: path,
      headers: headers
    }, (res) ->
      body = ""
      
      res.setEncoding('utf8')
      
      if (@options.rememberCookies) then @rememberCookies(res.headers)
      res.on 'data', (chunk) -> body += chunk
      res.on 'end', () -> callback(res, body)
    .on 'error', (e) =>
      util.error(e.toString().red)
      @prompt()
      
    request
    
  ### 设置cookies
  headers - the hash
  
  Example:
    setCookies(headers)
  ###
  setCookies: (headers) =>
    if ((keys = Object.keys(@cookies)).length)
      header = keys.filter (k) =>
        options = @cookies[k].options
        true
      .map (k) ->
        [k, querystring.escape(@cookies[k].value) || ''].join('=')
      .join(', ')
      header && (headers['Cookie'] = header)
    
  ### prompt 命令行前的提示
   
  ###
  prompt: ->
    path = '/' + @path.join('/')
    host = "#{@host}:#{@port}"
    arrow = '>'
    
    length = (host + path + arrow).length
   
    @readline.setPrompt((host).grey + path + arrow.grey, length)
    @readline.prompt()


  ### exec 执行脚本输入，控制操作函数
  command - The string to be executed
  ###
  exec: (command) =>
    headers = {}
    path = @path
    
    if (@pending)
      req = @request @pending.method, @pending.path, {'Content-length': command.length}, (res, body) =>
        @printResponse res, body, =>
          @prompt() 
      
      req.write(command)
      req.end()
      
      @pending = null
    else if (command[0] == '/')
      if command == '//' 
        @path = []
      else
        Array.prototype.push.apply(this.path, command.slice(1).split('/'))
    else if (command == '..')
      @path.pop()
    else if command[0] == '.'
      switch command.slice(1)
        when 'h', 'headers'
          exports.merge(headers, @headers)
          @setCookies(headers)
          @printHeaders(headers)
        when 'default-headers'
          @printHeaders(@headers)
        when 'o', 'options'
          inspect(@options)
        when 'c', 'cookies'
          inspect(@cookies)
        when 'help'
          puts(help)
        when 'j', 'json'
          @headers['Content-Type'] = 'application/json'
        when 'exit', 'quit', 'q'
          process.exit(0)
    else if (match = command.match(/^([a-zA-Z-]+):\s*(.*)/))
      if (match[2])
        @headers[match[1]] = match[2]
      else
        delete(@headers[match[1]])
    else if (/^(GET|POST|PUT|HEAD|DELETE)/i.test(command))
      command = command.split(/\s+/)
      method  = command.shift().toUpperCase()
      path    = @path.slice(0)
      
      if (command.length > 0) then path.push(command[0])
      
      path = ('/' + path.join('/')).replace(/\/+/g, '/')
      
      if (method == 'PUT' || method == 'POST')
        @pending = {method: method, path: path}
        this.dataPrompt()
      else 
        @request method, path, {}, (res, body) => 
          @printResponse res, body, => @prompt()
        .end()
      return
    else if (command)
      puts ("unknown command '#{command}'".yellow.bold)
    @prompt()
    
    
    # 打印回应
    # res - response
    # body - html内容段
    # callback - ()
    printResponse: (res, body, callback) => 
      status = "HTTP/#{res.httpVersion} #{res.statusCode} #{http.STATUS_CODES[res.statusCode]}".bold
      
      switch res.statusCode
        when (res.statusCode >= 500) then status = status.red
        when (res.statusCode >= 400) then status = status.yellow
        when (res.statusCode >= 300) then status = status.cyan
        else 
          status = status.green 
      
      puts status
      
      printHeaders(res.headers)
      puts 
      
      try
        output = JSON.parse(body)
      catch error
        output = body.trim() 
        
      if typeof(output) == 'string'
        output.length > 0 && print(output.white + '\n')
      else
        inspect(output)
        
      if (process.stdout.write(''))
        callback()
      else
        process.stdout.on 'drain', => callback()

   
     
   
console = new(Console)(host, port, options);
console.initialize();

