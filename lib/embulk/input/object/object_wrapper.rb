
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

    m = /http:\/\/([^:]+):([^@]+)@([^:]+):([0-9]+)/.match(ENV["http_proxy"])
    if m then
      logger.info "proxy: addr:#{m[3]}, port:#{m[4]}, id:#{m[1]}, pass:*****"
      Pardot::Client.http_proxy(
          user=m[1],
          pass=m[2],
          addr=m[3],
          port=m[4]
      )
      return
    end

    m = /http:\/\/([^:]+):([0-9]+)/.match(ENV["http_proxy"])
    if m then
      logger.info "proxy: addr:#{m[1]}, port:#{m[2]}"
      Pardot::Client.http_proxy(
          addr=m[1],
          port=m[2]
      )
      return
    end
  end

  def query(search_criteria, logger)
    offset = 0
    response = []
    logger.info "search criteria: #{search_criteria}"
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

