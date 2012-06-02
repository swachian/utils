Fs      = require 'fs'
#Log     = require 'log'
Path    = require 'path'

#  Write a script to compare two answers.  -- compare_answer.coffee
# The first one is stardard followed by an answer file. 
# Only the characters in the files make sense. Others will be just ignored.
#
# Example: 
    # coffee compare_answer.coffee stard.txt own.txt
    # => 'same: 55, disparities: 20'
class CompareAnswer
  # Public： diff two files by the given two path
  #
  # fp1 - The standard file path
  # fp2 - The other file path
  #
  # Example
  # diff('/tmp/1', '/tmp/2')
  # # => [55,20]
  #
  # Returns an array with two elements, the first is the number of the same, the second is the number differed
  diff: (fp1, fp2) ->

    Fs.readFile fp1, 'utf8', (err, data1) => 
      if (err) then throw err
      Fs.readFile fp2, 'utf8', (err, data2) =>
        if (err) then throw err

        data1 = @filterNoCharacters(data1)
        data2 = @filterNoCharacters(data2)       

        s = @compare(data1, data2)
        console.log "same: #{s[0]}, diff: #{s[1]}"  


  # Private: Compare two answer Strings and give the same count and different count
  #          The answer String must contain only answers
  #
  # answer1 - The string of standard answers
  # answer2 - The string of another answers
  #
  # Return an array, first element is the same number followed by the different number
  compare: (answer1, answer2) ->
    same = 0
    diff = 0
    
    for c, index in answer1 
      if c==answer2[index]
        same += 1
      else
        diff += 1
    [same, diff]
     
  # Private: Filter every byte not like 'A.....Z'
  #
  # io - The string to be filtered
  #
  # Exmaples
  # io = "1 A 2 B C C"
  # filterNoCharacters(io)
  # # => 'ABCC' 
  filterNoCharacters: (io) ->
    s = ""
    for c in io 
       if c.match /([A-Z]|[a-z])/
         s = s + c.toUpperCase() 
    s
  
cc = new CompareAnswer
#console.log(cc.filterNoCharacters("1 A 2 B C C"))
# console.log(cc.compare("ABA", "AABAA"))
cc.diff(process.argv[2], process.argv[3])
