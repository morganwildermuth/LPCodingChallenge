require_relative "text_parser.rb"
require_relative "test_methods.rb"

#set-up for tests
test_file = 'data.txt'
parse_test = TextParser.new(test_file)

# tests for getting initial values
assert(parse_test.get_item('meta data', 'correction text') == "I meant 'moderately,' not 'tediously,' above.")
assert(parse_test.get_item('header', 'accessed') == 205)
assert(parse_test.get_item('header', 'budget') == 4.5)

#tests for setting and retrieving added values
parse_test.add_value('priorities', 'mindset', 'constant learner')
parse_test.add_value('priorities', 'attitude', 'can do')
parse_test.add_value('extra priorities data', 'mindset degree of awesome', '10.01')

assert(parse_test.get_item('priorities', 'mindset') == 'constant learner')
assert(parse_test.get_item('priorities', 'attitude') == 'can do')
assert(parse_test.get_item('extra priorities data', 'mindset degree of awesome') == 10.01)

#tests for retrieving value in different format than saved
assert(parse_test.get_item('header', 'budget', 'integer') == 4)
assert(parse_test.get_item('header', 'accessed', 'float') == 205.0)
assert(parse_test.get_item('header', 'accessed', 'string') == "205")
assert(parse_test.get_item('priorities', 'mindset', 'integer') == 0)
assert(parse_test.get_item('priorities', 'mindset', 'float') == 0.0)

#test overwrite feature
parse_test.add_value('priorities', 'mindset', 'oompa loompa', 'true')
parse_test.add_value('priorities', 'mindset', 'stranger in a strange land')

assert(parse_test.get_item('priorities', 'mindset') == 'oompa loompa')

#set-up for resetting test data
reset_test_data(test_file)
parse_test = TextParser.new(test_file)

puts "And we're green; all tests have passed!"
