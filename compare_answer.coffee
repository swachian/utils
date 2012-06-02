Fs      = require 'fs'
#Log     = require 'log'
Path    = require 'path'

# * Write a script to compare two answers.  -- compare_answer.rb
# The first one is stardard followed by an answer file. 
# Only the characters in the files make sense. Others will be just ignored.
# Example: 
    # ruby compare_answer.rb stard.txt own.txt
    # => 'same: 55, disparities: 20'
# Pulic: Methods useful for performing comparing operations
#
# Examples
# CompareAnswer.compare(ARGV[0], ARGV[1])
# # => 'same: 55, disparities: 20'
class CompareAnswer
  # Public： diff two files by the given two path
  # fp1 - The standard file path
  # fp2 - The other file path
  # Example
  # diff('/tmp/1', '/tmp/2')
  # # => [55,20]
  #
  # Returns an array with two elements, the first is the number of the same, the second is the number differed
  diff: (fp1, fp2) ->
    data1 = ""
    data2 = ""
    
    Fs.open(fp1) { |f| data1 = f.read }
    Fs.open(fp2) { |f| data2 = f.read }
    
    data1 = filter_no_characters(data1)
    data2 = filter_no_characters(data2)
     
    same, diff = compare data1, data2
    puts "same: #{same}, diff: #{diff}"
  
  # Private: Compare two answer Strings and give the same count and different count
  #          The answer String must contain only answers
  # answer1 - The string of standard answers
  # answer2 - The string of another answers
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
  # io - The string to be filtered
  # Exmaples
  # io = "1 A 2 B C C"
  # filter_no_characters(io)
  # # => 'ABCC' 
  filter_no_characters: (io) ->
    s = ""
    for c in io 
       if c.match /[A-Z]/
        s = s + c 
    s
    
cc = new CompareAnswer
# console.log(cc.filter_no_characters("1 A 2 B C C"))
# console.log(cc.compare("ABA", "AABAA"))
console.log cc.diff(ARGV[0], ARGV[1])
