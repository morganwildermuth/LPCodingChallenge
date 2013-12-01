def create_test_data(file)
  test_file = file 
  file_by_line_array = File.readlines(test_file)
  File.open(test_file + "1", "w") do |file|
    file_by_line_array.each do |line|
      file.write(line)
    end
  end
end
