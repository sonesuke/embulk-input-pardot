require 'ruby-pardot'
require_relative 'object_wrapper'

class ListMembershipWrapper < ObjectWrapper

  def query(search_criteria)
    response = @client.list_memberships.query(search_criteria)
    normarize_as_array(response["list_membership"])
  end

  def get_counts(search_criteria)
    search_criteria[:limit] = 1
    response = @client.list_memberships.query(search_criteria)
    response["total_results"]
  end

  def get_profile
    [
        {:name => "id", :type => :long},
        {:name => "list_id", :type => :long},
        {:name => "prospect_id", :type => :long},
        {:name => "opted_out", :type => :long},
        {:name => "created_at", :type => :timestamp},
        {:name => "updated_at", :type => :timestamp},
    ]
  end
end

