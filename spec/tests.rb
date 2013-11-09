require_relative "../parser.rb"

def assert(arg)
  raise 'and we got a failure' unless arg
end

assert(Parse.new('data.rb').instance_of?(Parse))

puts "And we're green; all tests have passed!"