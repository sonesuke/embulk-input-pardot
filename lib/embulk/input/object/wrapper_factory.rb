require_relative 'prospect_wrapper'
require_relative 'visitor_wrapper'
require_relative 'visitor_activity_wrapper'
require_relative 'list_wrapper'
require_relative 'list_membership_wrapper'
require_relative 'visit_wrapper'
require_relative 'visitor_page_view_wrapper'

class WrapperFactory
  def self.create(type, user_name, password, user_key, logger)
    case type
    when "prospect" then
      return ProspectWrapper.new user_name, password, user_key, logger
    when "visitor" then
      return VisitorWrapper.new user_name, password, user_key, logger
    when "visitor_activity" then
      return VisitorActivityWrapper.new user_name, password, user_key, logger
    when "list" then
      return ListWrapper.new user_name, password, user_key, logger
    when "list_membership" then
      return ListMembershipWrapper.new user_name, password, user_key, logger
    when "visit" then
      return VisitWrapper.new user_name, password, user_key, logger
    when "visitor_page_view" then
      return VisitorPageViewWrapper.new user_name, password, user_key, logger
    else
      return ObjectWrapper.new
    end
  end
end

