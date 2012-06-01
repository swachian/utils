utils
=====

2012.6.1
Some script to assistant my business 
* Write a script to compare two answers.  -- compare_answer.rb
  The first one is stardard followed by an answer file. 
  Only the characters in the files make sense. Others will be just ignored.
  Example: 
  		ruby compare_answer.rb compare_answer_fixtures/stardard_answer.txt compare_answer_fixtures/own_answer.txt
        # => 'same: 55, disparities: 20'
