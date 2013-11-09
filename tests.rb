require_relative "parser.rb"

def assert(arg)
  raise 'and we got a failure' unless arg
end

parse_test = Parse.new('data.txt')
assert(parse_test.instance_of?(Parse))

puts "And we're green; all tests have passed!"

