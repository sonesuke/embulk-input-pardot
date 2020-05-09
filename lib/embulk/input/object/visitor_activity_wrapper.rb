require 'ruby-pardot'
require_relative 'object_wrapper'

class VisitorActivityWrapper < ObjectWrapper


  def initialize(user_name, password, user_key)
    @client = Pardot::Client.new user_name, password, user_key, 4
    @client.format = "full"
    @type_map = {
        "1" => "Click",
        "2" => "View",
        "3" => "Error",
        "4" => "Success",
        "5" => "Session",
        "6" => "Sent",
        "7" => "Search",
        "8" => "New Opportunity",
        "9" => "Opportunity Won",
        "10" => "Opportunity Lost",
        "11" => "Open",
        "12" => "Unsubscribe Page",
        "13" => "Bounced",
        "14" => "Spam Complaint",
        "15" => "Email Preference Page",
        "16" => "Resubscribed",
        "17" => "Click (Third Party)",
        "18" => "Opportunity Reopened",
        "19" => "Opportunity Linked",
        "20" => "Visit",
        "21" => "Custom URL click",
        "22" => "Olark Chat",
        "23" => "Invited to Webinar",
        "24" => "Attended Webinar",
        "25" => "Registered for Webinar",
        "26" => "Social Post Click",
        "27" => "Video View",
        "28" => "Event Registered",
        "29" => "Event Checked In",
        "30" => "Video Conversion",
        "31" => "UserVoice Suggestion",
        "32" => "UserVoice Comment",
        "33" => "UserVoice Ticket",
        "34" => "Video Watched (≥ 75% watched)",
        "35" => "Indirect Unsubscribe Open",
        "36" => "Indirect Bounce",
        "37" => "Indirect Resubscribed",
        "38" => "Opportunity Unlinked",
    }
  end

  def query_each(search_criteria)
    response = @client.visitor_activities.query(search_criteria)
    if response.has_key?("visitor_activity") then
      response["visitor_activity"].each do |activity|
        activity["type"] = @type_map.has_key?(activity["type"]) ? @type_map[activity["type"]] : "Other"
      end
      return response["total_results"], response["visitor_activity"]
    else
      return response["total_results"], []
    end
  end

  def get_profile
    result = [
        {:name => "id", :type => :long},
        {:name => "prospect_id", :type => :long},
        {:name => "visitor_id", :type => :long},
        {:name => "type", :type => :string},
        {:name => "type_name", :type => :string},
        {:name => "details", :type => :string},
        {:name => "email_id", :type => :long},
        {:name => "email_template_id", :type => :long},
        {:name => "list_email_id", :type => :long},
        {:name => "form_id", :type => :long},
        {:name => "form_handler_id", :type => :long},
        {:name => "site_search_query_id", :type => :long},
        {:name => "landing_page_id", :type => :long},
        {:name => "paid_search_ad_id", :type => :long},
        {:name => "multivariate_test_variation_id", :type => :long},
        {:name => "visitor_page_view_id", :type => :long},
        {:name => "file_id", :type => :long},
        {:name => "custom_redirect_id", :type => :long},
        {:name => "created_at", :type => :timestamp},
    ]

    return result
  end
end

