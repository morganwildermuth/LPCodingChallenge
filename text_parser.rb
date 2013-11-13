require_relative "line_parser"

class TextParser
  attr_reader :file, :file_hash

  def initialize(file)
    @file = file
    @file_hash = {}
    file_to_hash
  end

  def file_to_hash
    file_by_line_array = IO.readlines(file)
    current_section = nil
    file_by_line_array.each do |line|
      line = LineParser.new(line)
      if line.is_section?
        current_section = set_section(line)
      else
        unless line.is_blank_line?
          line.content.delete!("\n")
          if line.is_key_value_pair?
            current_key = set_key_value(line, current_section)
          else
            set_wrapped_value(line, current_section, current_key)
          end
        end
      end
    end
  end

  def set_section(line)
    current_section = line.parse_section
    file_hash[current_section] = {}
    current_section
  end

  def set_key_value(line, current_section)
    key_value = line.parse_key_value
    file_hash[current_section][key_value[0]] = key_value[1]
    key_value[0]
  end

  def set_wrapped_value(line, current_section, current_key)
    line = line.content
    file_hash[current_section][current_key] = file_hash[current_section][current_key] + line
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
    key = key.format
    value = value.format
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