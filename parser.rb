class Parse
  attr_reader :file, :file_hash

  def initialize(file)
    @file = file
    @file_hash = {}
    file_to_hash
  end

  def file_to_hash
    file_by_line_array = IO.readlines(file)
    current_section = 'empty'
    current_key = 'empty'
    file_by_line_array.each do |line|
      if line[0] == '['
        current_section = parse_section(line)
        file_hash[current_section] = {}
      else
        unless line[0] == "\n" 
          line = line.delete("\n")
          if line.include?(":")
            key_value = parse_key_value(line)
            file_hash[current_section][key_value[0]] = key_value[1]
            current_key = key_value[0]
          else
            wrapped_line = line
            file_hash[current_section][current_key] = file_hash[current_section][current_key] + wrapped_line
          end
        end
      end
    end
  end

  def parse_section(line)
    line_trimmed = line.gsub!(/\[|\]/, "")
    line_trimmed = line_trimmed.strip
  end

  def parse_key_value(line)
    key_value_pair = line.split(':')
    key = key_value_pair[0].strip
    value = key_value_pair[1].strip
    value.include?(".") ? value = value.to_f : value = value.to_i if is_a_number?(value)
    [key, value]
  end

  def is_a_number?(string)
    string == "0" || string.to_f != 0.0
  end

  def hash_to_file
    File.open(file, "w") do |file|
      file_hash.each do |key, value|
        file.puts("[#{key}]")
        value.each do |key, value|
          file.puts("#{key}: #{value}")
        end
      end
    end
  end

  def item_exists?(section, key)
    file_hash.has_key?(section) && file_hash[section].has_key?(key)
  end

  def return_item(section, key)
    file_hash[section][key]
  end

  def get_string(section, key)
    if item_exists?(section, key)
      return_item(section, key)
    else
      "No such item." 
    end
  end

  def get_integer(section, key)
    if item_exists?(section, key)
      return_item(section, key).to_i
    else
      "No such item." 
    end
  end

  def get_float(section, key)
    if item_exists?(section, key)
      return_item(section, key).to_f
    else
      "No such item." 
    end
  end

  def add_value(section, key, value)
    if file_hash[section].nil?
      file_hash[section] = {key => value}
      hash_to_file
    else
      current_hash = file_hash[section]
      current_hash[key] = value
      file_hash[section] = current_hash
      hash_to_file
    end
  end
end
