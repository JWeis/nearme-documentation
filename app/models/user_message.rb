# user-to-user message
class UserMessage < ActiveRecord::Base
  has_paper_trail
  acts_as_paranoid

  attr_accessor :replying_to_id

  belongs_to :author, class_name: 'User'           # person that wrote this message
  belongs_to :thread_owner, class_name: 'User'     # user that started conversation
  belongs_to :thread_recipient, class_name: 'User' # user that is conversation recipient
  belongs_to :thread_context, polymorphic: true    # conversation context: Listing, Reservation, User

  validates_presence_of :author_id
  validates_presence_of :thread_owner_id
  validates_presence_of :thread_recipient_id
  validates_presence_of :body, message: "Message can't be blank."
  validates_length_of :body, maximum: 2000, message: "Message cannot have more than 2000 characters."

  # Thread is defined by thread owner, thread recipient and thread context
  scope :for_thread, ->(thread_owner, thread_recipient, thread_context) {
    where(thread_context_id: thread_context.id, thread_context_type: thread_context.class.to_s, thread_owner_id: thread_owner.id, thread_recipient_id: thread_recipient.id)
  }

  scope :for_user, ->(user) {
    where('thread_owner_id = ? OR thread_recipient_id = ?', user.id, user.id).order('user_messages.created_at asc')
  }

  scope :by_created, -> {order('created_at desc')}

  after_create :update_recipient_unread_message_counter, :mark_as_read_for_author

  def thread_scope
    [thread_owner_id, thread_recipient_id, thread_context_id, thread_context_type]
  end

  def previous_in_thread
    UserMessage.find(replying_to_id)
  end

  def first_in_thread?
    replying_to_id.blank?
  end

  def read_column_for(user)
    "read_for_#{kind_for(user)}"
  end

  def read_for?(user)
    send read_column_for(user)
  end

  def unread_for?(user)
    !read_for?(user)
  end

  def mark_as_read_for!(user)
    column = read_column_for(user)
    send("#{column}=", true)
    save!
  end

  def archived_column_for(user)
    "archived_for_#{kind_for(user)}"
  end

  def archived_for?(user)
    send archived_column_for(user)
  end

  def archive_for!(user)
    column = archived_column_for(user)
    UserMessage.update_all({column => true},
                              { thread_owner_id: thread_owner_id,
                                thread_recipient_id: thread_recipient_id,
                                thread_context_id: thread_context_id,
                                thread_context_type: thread_context_type})
  end

  def to_liquid
    UserMessageDrop.new(self)
  end

  def send_notification(platform_context)
    return if thread_context_type.blank? or thread_context_type != 'Listing'
    UserMessageSmsNotifier.notify_user_about_new_message(platform_context, self).deliver
    if author == thread_context.administrator
      UserMessageMailer.enqueue.email_message_from_host(platform_context, self)
    else
      UserMessageMailer.enqueue.email_message_from_guest(platform_context, self)
    end
  end

  def recipient
    author_with_deleted == thread_owner_with_deleted ? thread_recipient_with_deleted : thread_owner_with_deleted
  end

  def thread_context_with_deleted
    return nil if thread_context_type.nil?
    @thread_context_with_deleted ||= thread_context_type.constantize.with_deleted.find_by_id(thread_context_id)
  end

  def author_with_deleted
    author.presence || User.with_deleted.find(author_id)
  end

  def thread_owner_with_deleted
    thread_owner.presence || User.with_deleted.find(thread_owner_id)
  end

  def thread_recipient_with_deleted
    thread_recipient.presence || User.with_deleted.find(thread_recipient_id)
  end

  def set_message_context_from_request_params(params)
    UserMessageThreadConfigurator.new(self, params).run
  end

  # check if author of this message can join conversation in message_context
  def author_has_access_to_message_context?
    case thread_context
    when Listing, User
      true
    when Reservation
      author == thread_context.owner ||
        author == thread_context.listing.administrator ||
        author == thread_context.listing.creator
    else
      false
    end
  end

  def update_unread_message_counter_for(user)
    actual_count = user.reload.decorate.unread_user_message_threads.fetch.size
    user.unread_user_message_threads_count = actual_count
    user.save!
  end

  private

  def kind_for(user)
    user.id == thread_owner_id ? :owner : :recipient
  end

  def update_recipient_unread_message_counter
    update_unread_message_counter_for(recipient)
  end

  def mark_as_read_for_author
    mark_as_read_for!(author) if author != recipient
  end
end
