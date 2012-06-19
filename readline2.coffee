# 读取用户输入的数字，然后告诉用户是否与state相同

colors = require 'colors'
util = require 'util'
readline = require 'readline'

class CmdBase
  constructor: (completions) ->
    @completions =  completions || '.help .q .quit .exit'.split(' ')
  
  welcome: ->
    util.puts([ "= readline-demo "
            , "= Welcome, enter .help if you're lost."
            , "= Try counting from 1 to 5!"
            ].join('\n').grey)
  
  prompt: ->
    @rl.setPrompt(">".green, ">".length)
    @rl.prompt()
  
  listen: (exec) ->
    @rl = readline.createInterface process.stdin, process.stdout, (line) =>
      hits = @completions.filter (c) ->
        if c.indexOf(line) == 0 then c 
      if hits && hits.length >0 then [hits, line] else [@completions, line]
    @welcome()
    @prompt()
    
    exec ||= @exec
    @rl.on 'line', (line) ->
      exec(line.trim())
    .on 'close', ->
      console.log("Goodbye".red)
      process.exit(0)
   
   exec: (line)->
     util.puts("You have input a command: #{line}. Please give an exec as well")

      


class Cmd extends CmdBase
  state: 0
  exec: (line) =>
    num = parseInt(line)
    if (1<= num && num <= 5)
      state = ++@state
      if (state == num)
        util.puts("HIT".green)
      else if (state >= 6)
        util.puts 'WOW YOU ROCKS A LOT!'.rainbow
        process.exit(0)
      else
        util.puts "Try #{state}".red
    else 
      switch line[0]
      
  
cmd = new Cmd(null)
cmd.listen(null)