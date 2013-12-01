def reset_test_data(file)
  test_file = file 
  file_by_line_array = File.readlines(test_file)
  File.open(test_file, "w") do |file|
    file_by_line_array.each do |line|
      file.puts(line) unless line.include?("priorities") || line.include?("mindset") || line.include?("attitude")
    end
  end
end