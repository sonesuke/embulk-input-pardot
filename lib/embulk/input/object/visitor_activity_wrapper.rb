require 'ruby-pardot'
require_relative 'pardot_object_wrapper'

class VisitorActivityWrapper < PardotObjectWrapper

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
      response = @client.visitor_activities.query(search_criteria)
      if offset == 0 then
        counts = response["total_results"]
      end
      logger.info "query (remain %s)" % (counts)
      counts -= 200
      offset += 200
      result += response["visitor_activity"]
    end
    return result
  end

  def get_profile
    result = [
        {:name => "id", :type => :long},
        {:name => "prospect_id", :type => :long},
        {:name => "visitor_id", :type => :long},
        {:name => "type", :type => :long},
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

