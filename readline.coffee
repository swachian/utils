readline = require 'readline'
util = require 'util'
colors = require 'colors'

rl = readline.createInterface process.stdin, process.stdout, (line) ->
  completions = '.help .error .exit .quit .q'.split(' ')
  hits = completions.filter (c) ->
    return c if (c.indexOf(line) == 0)
  if (hits && hits.length) then [hits, line] else [completions, line]

welcome = ->
  util.puts([ "= readline-demo "
            , "= Welcome, enter .help if you're lost."
            , "= Try counting from 1 to 5!"
            ].join('\n').grey)

prompt = ->
  arrow = ">"
  length = arrow.length
  rl.setPrompt(arrow.green, length)
  rl.prompt()

state = 1
exec = (command) ->
  num = parseInt(command, 10)
  if (1 <= num && num <= 5)
    if state == num
      state++;
      console.log('WIN'.green)
    else
      console.log(('Try entering a different number, like ' + state + ' for example').red);
    if state ==6
      console.log('WOW YOU ROCKS A LOT!'.rainbow)
      process.exit(0)
  else if (command[0] == '.')
    switch command.slice(1)
      when 'help' then util.puts(help.yellow)
  else
    if (command != '')
      console.log("'#{command}' is not a command due, sorryz".yellow)
  prompt()
    

rl.on 'line', (cmd) ->
  exec(cmd.trim())
.on 'close', ->
  util.puts('goodbye!'.green)
  process.exit(0)

process.on 'uncaughtExecption', (e) ->
  util.puts(e.stack.red)
  rl.prompt
  
welcome()
prompt()
