# 读取用户输入的数字，然后告诉用户是否与state相同

colors = require 'colors'
readline = require 'readline'
util = require 'util'

rl = readline.createInterface process.stdin, process.stdout, (line) ->
  completers = '.help .q .quit .exit'.split(/\s/)
  hits = completers.filter (command) -> 
    return command.blue if command.match(line)
  if hits && hits.length > 0 then [hits, line] else [completers, line]

welcome = ->
  console.log("Please come here".green)

prompt = ->
  rl.setPrompt(">".blue, ">".length)
  rl.prompt()

state = 1
exec = (command)->
  num = parseInt(command)
  if (1<= num && num <=5)
    if (state == num)
      state++
      console.log('WIN'.green)
    else 
      console.log(('Try entering a different number, like ' + state + ' for example').red);
    if state == 6 
      console.log('WOW YOU ROCKS A LOT!'.rainbow)
      process.exit(0)      
  else if (command.match(/^\./))
    switch command.slice(1)
      when 'help'
        console.log("The help is such")

rl.on 'line', (command) ->
  exec(command)
  prompt()
.on 'close', ->
  process.exit(0)

welcome()
prompt()
