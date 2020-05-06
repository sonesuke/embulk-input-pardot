require 'ruby-pardot'
require_relative 'pardot_object_wrapper'

class VisitorWrapper < PardotObjectWrapper

  def initialize(user_name, password, user_key)
    @client = Pardot::Client.new user_name, password, user_key, 4
    @client.format = "full"
  end

  def query(search_criteria, logger)
    counts = 200
    offset = 0
    result = []
    while counts > 0 do
      search_criteria[:offset] = offset
      response = @client.visitors.query(search_criteria)
      if offset == 0 then
        counts = response["total_results"]
      end
      logger.info "query (remain %s)" % (counts)
      counts -= 200
      offset += 200
      if response.has_key?("visitor") then
        result += response["visitor"]
      end
    end
    return result
  end

  def get_profile
    result = [
        {:name => "id", :type => :long},
        {:name => "page_view_count", :type => :long},
        {:name => "ip_address", :type => :string},
        {:name => "hostname", :type => :string},
        {:name => "campaign_parameter", :type => :string},
        {:name => "medium_parameter", :type => :string},
        {:name => "source_parameter", :type => :string},
        {:name => "content_parameter", :type => :string},
        {:name => "term_parameter", :type => :string},
        {:name => "created_at", :type => :timestamp},
        {:name => "updated_at", :type => :timestamp},
    ]

    return result
  end
end

