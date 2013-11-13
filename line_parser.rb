require_relative "string_class_methods"

class LineParser
  attr_reader :content

  def initialize(line)
    @content = line
  end

  def is_section?
    content[0] == '['
  end

  def parse_section
    content_trimmed = content.gsub!(/\[|\]/, "")
    content_trimmed = content_trimmed.strip
  end

  def is_blank_line?
    content[0] == "\n"
  end

  def is_key_value_pair?
    content.include?(":") && !(self.is_blank_line?)
  end

  def parse_key_value
    key_value_pair = content.split(':')
    key_value_pair.map!{|e| e.strip}
    key = key_value_pair[0].format
    value = key_value_pair[1].format
    [key, value]
  end
end