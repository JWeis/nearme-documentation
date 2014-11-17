class DataUpload < ActiveRecord::Base
  has_paper_trail
  acts_as_paranoid
  auto_set_platform_context
  scoped_to_platform_context

  belongs_to :instance
  belongs_to :transactable_type
  belongs_to :uploader, class_name: 'User'
  belongs_to :target, polymorphic: true
  serialize :parse_summary, Hash

  mount_uploader :csv_file, DataImportFileUploader
  mount_uploader :xml_file, DataImportFileUploader
  validates :csv_file, :presence => true, :file_size => { :maximum => 10.megabytes.to_i }

  store :options, accessors: [ :send_invitational_email, :sync_mode ], coder: Hash
  scope :for_transactable_type, -> (transactable_type) { where(transactable_type: transactable_type) }

  def sync_mode
    ActiveRecord::ConnectionAdapters::Column.value_to_boolean(super)
  end

  def send_invitational_email
    ActiveRecord::ConnectionAdapters::Column.value_to_boolean(super)
  end

end

