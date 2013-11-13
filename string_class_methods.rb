class String
  def format
    if is_a_number?
      self.include?(".") ? self.to_f : self.to_i
    else
      self
    end
  end

  def is_a_number?
    self == "0" || self.to_f != 0.0
  end
end