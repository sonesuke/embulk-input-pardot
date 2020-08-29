require 'ruby-pardot'
require_relative 'object_wrapper'

class ListWrapper < ObjectWrapper

  def query(search_criteria)
    response = @client.lists.query(search_criteria)
    normarize_as_array(response["list"])
  end

  def get_counts(search_criteria)
    search_criteria[:limit] = 1
    response = @client.lists.query(search_criteria)
    response["total_results"]
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

