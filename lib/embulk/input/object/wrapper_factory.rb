require_relative 'prospect_wrapper'
require_relative 'visitor_wrapper'
require_relative 'visitor_activity_wrapper'
require_relative 'list_wrapper'
require_relative 'list_membership_wrapper'

class WrapperFactory
  def self.create(type, user_name, password, user_key)
    case type
    when "prospect" then
      return ProspectWrapper.new user_name, password, user_key
    when "visitor" then
      return VisitorWrapper.new user_name, password, user_key
    when "visitor_activity" then
      return VisitorActivityWrapper.new user_name, password, user_key
    when "list" then
      return ListWrapper.new user_name, password, user_key
    when "list_membership" then
      return ListMembershipWrapper.new user_name, password, user_key
    else
      return ObjectWrapper.new
    end
  end
end

