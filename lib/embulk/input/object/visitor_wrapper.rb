require 'ruby-pardot'
require_relative 'object_wrapper'

class VisitorWrapper < ObjectWrapper

  def initialize(user_name, password, user_key)
    @client = Pardot::Client.new user_name, password, user_key, 4
    @client.format = "full"
  end

  def query_each(search_criteria)
    response = @client.visitors.query(search_criteria)
    return response["total_results"], response.has_key?("visitor") ? response["visitor"]: []
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

