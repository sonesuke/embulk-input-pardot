
class PardotObjectWrapper
  def query(search_criteria, logger)
    raise NotImplementedError.new("#{self.class}##{__method__} is not implmented.")
  end

  def get_profile
      raise NotImplementedError.new("#{self.class}##{__method__} is not implmented.")
  end
end

