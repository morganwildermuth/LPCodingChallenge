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
    value = number_or_string(value)
    [key, value]
  end

  def is_a_number?(string)
    string == "0" || string.to_f != 0.0
  end

  def number_or_string(string)
    if is_a_number?(string)
      string.include?(".") ? string = string.to_f : string = string.to_i if is_a_number?(string)
    else
      string
    end
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

  def transform_item(section, key, type = "given")
    item = return_item(section, key)
    case type
    when "string"
      item.to_s
    when "float"
      item.to_f
    when "integer"
      item.to_i
    when "given"
      item
    end
  end

  def return_item(section, key)
    if item_exists?(section, key)
      return_item(section, key)
    else
      "No such item." 
    end
  end

  def add_value(section, key, value)
    value = number_or_string(value)
    key = number_or_string(key)
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
