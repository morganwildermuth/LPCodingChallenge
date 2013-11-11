require_relative "parser.rb"

def assert(arg)
  raise 'and we got a failure' unless arg
end

def reset_test_data(file)
  test_file = file 
  file_by_line_array = File.readlines(test_file)
  File.open(test_file, "w") do |file|
  file_by_line_array.each { |line| 
    file.puts(line) unless line.include?("priorities") || line.include?("mindset") }
  end
end

test_file = 'data.txt'

# tests for getting
parse_test = Parse.new(test_file)

assert(parse_test.get_string('meta data', 'correction text') == "I meant 'moderately,' not 'tediously,' above.")
assert(parse_test.get_integer('header', 'budget') == 4)
assert(parse_test.get_float('header', 'budget') == 4.5)

#tests for setting
parse_test.add_value('priorities', 'mindset', 'constant learner')
parse_test.add_value('extra priorities data', 'mindset degree of awesome', '10.01')
parse_test = Parse.new(test_file)

assert(parse_test.get_string('priorities', 'mindset') == 'constant learner')
assert(parse_test.get_integer('extra priorities data', 'mindset degree of awesome') == 10)
assert(parse_test.get_float('extra priorities data', 'mindset degree of awesome') == 10.01)

#tests for resetting test data
reset_test_data(test_file)
parse_test = Parse.new(test_file)

assert(parse_test.get_string('priorities', 'mindset') == 'No such item.')

puts "And we're green; all tests have passed!"
