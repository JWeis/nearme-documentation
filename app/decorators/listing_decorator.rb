class ListingDecorator < Draper::Decorator
  include Draper::LazyHelpers

  delegate_all

  def user_message_recipient
    administrator
  end

  def user_message_summary(user_message)
    link_to user_message.thread_context.name, location_listing_path(user_message.thread_context.location, user_message.thread_context)
  end
end
