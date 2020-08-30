require 'ruby-pardot'
require_relative 'object_wrapper'

class VisitorPageViewWrapper < ObjectWrapper

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
    visits = normarize_as_array(response["visit"])
    page_views = []
    visits.each do |visit|
      visitor_page_views = visit["visitor_page_views"]
      if visitor_page_views.kind_of? Hash then
        page_view = normarize_as_array(visitor_page_views["visitor_page_view"])
        page_view.each do |page_view|
          page_view["visit_id"] = visit["id"]
        end
        page_views.concat page_view
      end
    end
    page_views
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
        {:name => "url", :type => :string},
        {:name => "title", :type => :string},
        {:name => "visit_id", :type => :long},
        {:name => "created_at", :type => :timestamp},
    ]
  end
end

