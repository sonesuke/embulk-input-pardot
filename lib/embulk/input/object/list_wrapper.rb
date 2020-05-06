require 'ruby-pardot'
require_relative 'pardot_object_wrapper'

class ListWrapper < PardotObjectWrapper

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
      response = @client.lists.query(search_criteria)
      if offset == 0 then
        counts = response["total_results"]
      end
      logger.info "query (remain %s)" % (counts)
      counts -= 200
      offset += 200
      if response.has_key?("list") then
        result += response["list"]
      end
    end
    return result
  end

  def get_profile
    result = [
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

    return result
  end
end

