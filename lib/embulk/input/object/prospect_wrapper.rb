require 'ruby-pardot'
require_relative 'object_wrapper'

class ProspectWrapper < ObjectWrapper

  def query_each(search_criteria)
    response = @client.prospects.query(search_criteria)
    return response["total_results"], response.has_key?("prospect") ? response["prospect"]: []
  end

  def get_profile
    result = [
        {:name => "id", :type => :long},
        {:name => "campaign_id", :type => :long},
        {:name => "salutation", :type => :string},
        {:name => "first_name", :type => :string},
        {:name => "last_name", :type => :string},
        {:name => "email", :type => :string},
        {:name => "password", :type => :string},
        {:name => "company", :type => :string},
        {:name => "prospect_account_id", :type => :long},
        {:name => "website", :type => :string},
        {:name => "job_title", :type => :string},
        {:name => "department", :type => :string},
        {:name => "country", :type => :string},
        {:name => "address_one", :type => :string},
        {:name => "address_two", :type => :string},
        {:name => "city", :type => :string},
        {:name => "state", :type => :string},
        {:name => "territory", :type => :string},
        {:name => "zip", :type => :string},
        {:name => "phone", :type => :string},
        {:name => "fax", :type => :string},
        {:name => "source", :type => :string},
        {:name => "annual_revenue", :type => :string},
        {:name => "employees", :type => :string},
        {:name => "industry", :type => :string},
        {:name => "years_in_business", :type => :string},
        {:name => "comments", :type => :string},
        {:name => "notes", :type => :string},
        {:name => "score", :type => :long},
        {:name => "grade", :type => :string},
        {:name => "last_activity_at", :type => :timestamp},
        {:name => "recent_interaction", :type => :string},
        {:name => "crm_lead_fid", :type => :string},
        {:name => "crm_contact_fid", :type => :string},
        {:name => "crm_owner_fid", :type => :string},
        {:name => "crm_account_fid", :type => :string},
        {:name => "crm_last_sync", :type => :timestamp},
        {:name => "crm_url", :type => :string},
        {:name => "is_do_not_email", :type => :boolean},
        {:name => "is_do_not_call", :type => :boolean},
        {:name => "opted_out", :type => :boolean},
        {:name => "is_reviewed", :type => :boolean},
        {:name => "is_starred", :type => :boolean},
        {:name => "created_at", :type => :timestamp},
        {:name => "updated_at", :type => :timestamp},
    ]

    # custom field is not implemented yet at ruby-pardot 1.3.1.
    response = @client.get "customField", "/do/query", {:sort_by => "created_at", :sort_order => "ascending"}
    response["result"]["customField"].each do | custom_field |
      case custom_field["type"]
      when "Checkbox" then
        result << {:name => custom_field["field_id"], :type => :boolean}
      when "Number" then
        result << {:name => custom_field["field_id"], :type => :long}
      when "Date" then
        result << {:name => custom_field["field_id"], :type => :timestamp}
      else
        result << {:name => custom_field["field_id"], :type => :string}
      end
    end
    return result
  end
end

