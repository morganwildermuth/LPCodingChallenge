class Parse
  attr_reader :file

  def initialize(file)
    @file = File.open(file)
  end

  def get_string(section, key)
  end

  def get_integer(section, key)
  end

  def get_floating_point(section, key)
  end

  def set_string(section, key)
  end

  def set_integer(section, key)
  end

  def set_floating_point(section, key)
  end
end

