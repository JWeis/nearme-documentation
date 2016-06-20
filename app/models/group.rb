class Group < ActiveRecord::Base
  acts_as_paranoid
  auto_set_platform_context
  scoped_to_platform_context

  include QuerySearchable

  mount_uploader :cover_image, GroupCoverImageUploader

  belongs_to :transactable_type, -> { with_deleted }, foreign_key: 'transactable_type_id', class_name: 'GroupType'
  belongs_to :group_type, -> { with_deleted }, foreign_key: 'transactable_type_id'
  belongs_to :creator, -> { with_deleted }, class_name: "User", inverse_of: :groups

  has_many :photos, as: :owner, dependent: :destroy
  has_many :links, as: :linkable, dependent: :destroy

  has_many :group_projects, dependent: :destroy
  has_many :projects, through: :group_projects

  has_many :group_members, dependent: :destroy
  has_many :memberships, class_name: 'GroupMember', dependent: :destroy
  has_many :members, through: :group_members, source: :user
  has_many :approved_members, -> { GroupMember.approved }, through: :group_members, source: :user

  has_many :activity_feed_events, as: :event_source, dependent: :destroy

  has_custom_attributes target_type: 'GroupType', target_id: :transactable_type_id

  accepts_nested_attributes_for :photos, allow_destroy: true
  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  scope :with_date, ->(date) { where(created_at: date) }
  scope :by_search_query, lambda { |query|
    where('name ilike ? or description ilike ? or summary ilike ?', query, query, query)
  }

  with_options unless: ->(record) { record.draft? } do |options|
    options.validates :transactable_type, presence: true
    options.validates :cover_image, presence: true
    options.validates :name, presence: true, length: { maximum: 140 }
    options.validates :summary, presence: true, length: { maximum: 140 }
    options.validates :description, presence: true, length: { maximum: 5000 }
  end

  after_save :trigger_workflow_alert_for_added_group_members, unless: ->(record) { record.draft? }
  after_commit :user_created_group_event, on: :create, unless: ->(record) { record.draft? }

  delegate :public?, :moderated?, :private?, to: :group_type

  def to_liquid
    @group_drop ||= GroupDrop.new(self)
  end

  def draft?
    draft_at.present?
  end

  def enabled?
    draft_at.nil?
  end

  def build_new_group_member
    OpenStruct.new(email: nil, moderator: false)
  end

  def new_group_members
    (@new_group_members || []).empty? ? [OpenStruct.new(email: nil, moderator: false)] : @new_group_members
  end

  def new_group_members_attributes=(attributes = {})
    @new_group_members = attributes.values.uniq { |member| member[:email] }.map do |member|
      OpenStruct.new(email: member[:email], moderator: member[:moderator]) unless member[:email].blank?
    end.compact
  end

  def user_created_group_event
    event = :user_created_group
    user = self.creator.try(:object).presence || self.creator
    affected_objects = [user]
    ActivityFeedService.create_event(event, self, affected_objects, self)
  end

  def trigger_workflow_alert_for_added_group_members
    return true if @new_group_members.nil?

    @new_group_members.each do |group_member|
      group_member_email = group_member.email.try(:downcase)
      user = User.find_by(email: group_member_email)
      next unless user.present?

      unless group_members.for_user(user).exists?
        gm = self.group_members.build(
          user: user,
          email: group_member_email,
          moderator: group_member.moderator,
          approved_by_owner_at: Time.zone.now
        )
        gm.save!

        WorkflowStepJob.perform(WorkflowStep::GroupWorkflow::MemberAddedByGroupOwner, gm.id)
      end

    end
  end

  class NotFound < ActiveRecord::RecordNotFound; end
end