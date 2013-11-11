class Parse
  attr_reader :file, :file_by_line_array, :file_hash

  def initialize(file)
    @file = file
    @file_hash = {}
    @file_by_line_array = IO.readlines(file)
    file_to_hash
  end

  def file_to_hash
    line_trimmed = 'empty'
    current_key = 'empty'
    file_by_line_array.each do |line|
      if line[0] == '['
        line_trimmed = line.gsub!(/\[|\]/, "")
        line_trimmed = line_trimmed.strip
        file_hash[line_trimmed] = {}
      else
        unless line[0] == "\n" 
          line = line.delete("\n")
          if line.include?(":")
            if !(line.nil?)
              key_value_pair = line.split(':')
              key = key_value_pair[0].strip
              value = key_value_pair[1].strip
              file_hash[line_trimmed][key] = value
              current_key = key
            end
          else
            file_hash[line_trimmed][current_key] = file_hash[line_trimmed][current_key] + line
          end
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
    File.open(file, "a") do |file| 
      file.puts('[' + section + ']') 
      file.puts(key + ':' + value) 
    end
  end
end
