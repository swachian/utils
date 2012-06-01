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
module CompareAnswer
  # Public： diff two files by the given two path
  # fp1 - The standard file path
  # fp2 - The other file path
  # Example
  # diff('/tmp/1', '/tmp/2')
  # # => [55,20]
  #
  # Returns an array with two elements, the first is the number of the same, the second is the number differed
  def self.diff(fp1, fp2)
    data1, data2 = "", ""
    
    File.open(fp1) { |f| data1 = f.read }
    File.open(fp2) { |f| data2 = f.read }
    
    data1 = filter_no_characters(data1)
    data2 = filter_no_characters(data2)
    
    same, diff = compare data1, data2
    puts "same: #{same}, diff: #{diff}"
  end
  
  # Private: Compare two answer Strings and give the same count and different count
  #          The answer String must contain only answers
  # answer1 - The string of standard answers
  # answer2 - The string of another answers
  def self.compare(answer1, answer2)
    same, diff = 0, 0
    
    answer1.split(//).each_with_index do |c, index|
      if c==answer2[index]
        same += 1
      else
        diff += 1
      end 
    end 
    [same, diff]
  end
  
  # Private: Filter every byte not like 'A.....Z'
  # io - The string to be filtered
  # Exmaples
  # io = "1 A 2 B C C"
  # filter_no_characters(io)
  # # => 'ABCC' 
  def self.filter_no_characters(io)
    s = ""
    io.split(//).each do |c|
      s = s + c if (c =~ /[A-Z]/)
    end
    s
  end
end

# puts CompareAnswer.filter_no_characters "1 A 2 B C C"
# puts CompareAnswer.compare "ABAAAA", "AABAA"
CompareAnswer.diff ARGV[0], ARGV[1]
