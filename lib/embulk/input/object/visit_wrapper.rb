require 'ruby-pardot'
require_relative 'object_wrapper'

class VisitWrapper < ObjectWrapper

  def query(search_criteria)
    response = @client.visitor_activities.query(search_criteria)
    response["visitor_activity"] = normarize_as_array(response["visitor_activity"])

    visit_ids = []
    response["visitor_activity"].each do |activity|
      if activity.has_key? "visit_id" then
        visit_ids.push activity["visit_id"]
      end
    end
    search_criteria.delete :offset
    search_criteria[:ids] = visit_ids.join ","
    response = post "/do/query", search_criteria, "result"
    normarize_as_array(response["visit"])
  end

  def post(path, params = {}, result = "visit")
    response = @client.post "visit", path, params
    result ? response[result] : response
  end

  def get_counts(search_criteria)
    search_criteria[:limit] = 1
    response = @client.visitor_activities.query(search_criteria)
    response["total_results"]
  end

  def get_profile
    [
        {:name => "id", :type => :long},
        {:name => "visitor_id", :type => :long},
        {:name => "prospect_id", :type => :long},
        {:name => "visitor_page_view_count", :type => :long},
        {:name => "first_visitor_page_view_at", :type => :timestamp},
        {:name => "last_visitor_page_view_at", :type => :timestamp},
        {:name => "duration_in_seconds", :type => :long},
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

