require 'ruby-pardot'
require_relative 'object_wrapper'

class ListWrapper < ObjectWrapper

  def query_each(search_criteria)
    response = @client.lists.query(search_criteria)
    return response["total_results"], response.has_key?("list") ? response["list"]: []
  end

  def get_profile
    [
        {:name => "id", :type => :long},
        {:name => "name", :type => :string},
        {:name => "is_public", :type => :boolean},
        {:name => "is_dynamic", :type => :boolean},
        {:name => "title", :type => :string},
        {:name => "description", :type => :string},
        {:name => "is_crm_visible", :type => :boolean},
        {:name => "created_at", :type => :timestamp},
        {:name => "updated_at", :type => :timestamp},
    ]
  end
end

