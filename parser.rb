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
      if is_section?(line)
        current_section = set_section(line)
      else
        unless is_blank_line?(line)
          line = line.delete("\n")
          if is_key_value_pair?(line)
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

  def set_section(line)
    current_section = parse_section(line)
    file_hash[current_section] = {}
    current_section
  end

  def is_section?(line)
    line[0] == '['
  end

  def parse_section(line)
    line_trimmed = line.gsub!(/\[|\]/, "")
    line_trimmed = line_trimmed.strip
  end

  def is_blank_line?(line)
    line[0] == "\n"
  end

  def is_key_value_pair?(line)
    line.include?(":")
  end

  def parse_key_value(line)
    key_value_pair = line.split(':')
    key = key_value_pair[0].strip
    value = key_value_pair[1].strip
    value = format(value)
    [key, value]
  end

  def format(string)
    if is_a_number?(string)
      string.include?(".") ? string.to_f : string.to_i
    else
      string
    end
  end

  def is_a_number?(string)
    string == "0" || string.to_f != 0.0
  end

  def get_item(section, key, type = "given")
    if type != "given"
      transform_item(section, key, type)
    else
      if item_exists?(section, key)
        return_item(section, key)
      else
        "No such item."
      end
    end
  end

  def transform_item(section, key, type)
    item = get_item(section, key)
    case type
    when "string"
      item.to_s
    when "float"
      item.to_f
    when "integer"
      item.to_i
    end
  end

  def item_exists?(section, key)
    file_hash.has_key?(section) && file_hash[section].has_key?(key)
  end

  def return_item(section, key)
    file_hash[section][key]
  end

  def add_value(section, key, value, overwrite = nil)
    value = format(value)
    key = format(key)
    if new?(section)
      file_hash[section] = {key => value}
      hash_to_file
    else
      current_section_hash = file_hash[section]
      if current_section_hash[key].nil? || overwrite == 'overwrite'
        current_section_hash[key] = value
        file_hash[section] = current_section_hash
        hash_to_file
      end
    end
  end

  def new?(section)
    file_hash[section].nil?
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
end
