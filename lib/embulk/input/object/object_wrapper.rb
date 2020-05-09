
class ObjectWrapper

  def query(search_criteria, logger)
    offset = 0
    response = []
    loop do
      search_criteria[:offset] = offset
      counts, result = query_each(search_criteria)
      response += result
      logger.info "query (remain %s)" % (counts - offset < 0? 0 : counts - offset)
      offset += 200
      break if offset > counts
    end
    return response
  end

  def query_each(search_criteria)
    raise NotImplementedError.new("#{self.class}##{__method__} is not implmented.")
  end

  def get_profile
      raise NotImplementedError.new("#{self.class}##{__method__} is not implmented.")
  end
end

