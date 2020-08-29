require 'uri'

class ObjectWrapper

  def initialize(user_name, password, user_key, logger)
    @client = Pardot::Client.new user_name, password, user_key, 4
    @client.format = "full"
    evalutate_proxy(logger)
  end

  def evalutate_proxy(logger)
    if not ENV.has_key?("http_proxy") then
      return
    end
    parsed = URI.parse(ENV["http_proxy"])
    logger.info "proxy: addr:#{parsed.host}, port:#{parsed.port}, id:#{parsed.user}, pass:*****"
    Pardot::Client.http_proxy(parsed.host, parsed.port, parsed.user,parsed.password)
  end

  def normarize_as_array(value)
    if value == nil then
      return []
    end
    return value.kind_of?(Array) ? value: [value]
  end

  def get_counts(search_criteria)
    raise NotImplementedError.new("#{self.class}##{__method__} is not implemented.")
  end

  def query(search_criteria)
    raise NotImplementedError.new("#{self.class}##{__method__} is not implemented.")
  end

  def get_profile
    raise NotImplementedError.new("#{self.class}##{__method__} is not implemented.")
  end
end

