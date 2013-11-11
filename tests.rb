require_relative "parser.rb"

def assert(arg)
  raise 'and we got a failure' unless arg
end

parse_test = Parse.new('data.txt')

assert(parse_test.instance_of?(Parse))
assert(parse_test.get_string('meta data', 'correction text') == "I meant 'moderately,' not 'tediously,' above.")
assert(parse_test.get_integer('header', 'budget') == 4)
assert(parse_test.get_float('header', 'budget') == 4.5)

parse_test.set_string('priorities', 'mindset', 'constant learner')

assert(parse_test.get_string('top priority', 'mindset') == 'constant learner')


puts "And we're green; all tests have passed!"