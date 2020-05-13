require 'ruby-pardot'
require_relative 'object_wrapper'

class ListMembershipWrapper < ObjectWrapper

  def query_each(search_criteria)
    response = @client.list_memberships.query(search_criteria)
    return response["total_results"], response.has_key?("list_membership") ? response["list_membership"]: []
  end

  def get_profile
    result = [
        {:name => "id", :type => :long},
        {:name => "list_id", :type => :long},
        {:name => "prospect_id", :type => :long},
        {:name => "opted_out", :type => :long},
        {:name => "created_at", :type => :timestamp},
        {:name => "updated_at", :type => :timestamp},
    ]
    return result
  end
end

