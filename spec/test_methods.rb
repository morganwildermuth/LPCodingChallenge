def assert(arg)
  raise 'red blinking lights of doom: aka you have a failing test' unless arg
end

def reset_test_data(file)
  test_file = file 
  file_by_line_array = File.readlines(test_file)
  File.open(test_file, "w") do |file|
  file_by_line_array.each { |line| 
    file.puts(line) unless line.include?("priorities") || line.include?("mindset") || line.include?("attitude") }
  end
end