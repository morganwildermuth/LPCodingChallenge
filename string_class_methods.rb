class String
  def format
    if is_a_number?
      self.include?(".") ? self.to_f : self.to_i
    else
      self
    end
  end

  def is_a_number?
    self =~ /\A\.?\d+\.?\d*$/ ? true : false
  end
end