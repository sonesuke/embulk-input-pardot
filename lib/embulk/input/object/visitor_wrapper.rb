require 'ruby-pardot'
require_relative 'object_wrapper'

class VisitorWrapper < ObjectWrapper

  def query(search_criteria)
    response = @client.visitors.query(search_criteria)
    normarize_as_array(response["visitor"])
  end

  def get_counts(search_criteria)
    search_criteria[:limit] = 1
    response = @client.visitors.query(search_criteria)
    response["total_results"]
  end

  def get_profile
    [
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
  end
end

