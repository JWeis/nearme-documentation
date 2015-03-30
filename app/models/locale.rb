class Locale < ActiveRecord::Base
  auto_set_platform_context
  scoped_to_platform_context

  # Generates /^\/(aa|ab|af|ak|sq|am|ar|an|hy|as|...|zu)(?=\/|$)/
  DOMAIN_PATTERN = %r(^/(#{I18nData.languages.map { |l| Regexp.escape(l[0].downcase) }.join('|')})(?=/|$))

  belongs_to :instance

  validates_presence_of :code, :instance_id
  validates_uniqueness_of :code, scope: :instance_id

  before_save :remove_primary

  before_destroy :check_locale
  after_destroy :delete_instance_keys

  def self.remove_locale_from_url(url)
    url.sub!(DOMAIN_PATTERN) { $2 || '' }
    url.replace('/') if url.empty?
    $1
  end

  def self.primary
    find_by primary: true
  end

  def self.default_locale
    find_by(primary: true).try(:code).try(:to_sym)
  end

  def self.available_locales
    pluck(:code).map(&:to_sym)
  end

  def name
    I18nData.languages[code.upcase]
  end

  def display_name
    custom_name.blank? ? name : custom_name
  end

  private

  def remove_primary
    self.class.where(primary: true).where.not(id: id).update_all primary: false if primary?
  end

  def check_locale
    if code == 'en'
      errors[:base] << "You can't delete English locale"
      return false
    end

    if primary?
      errors[:base] << "You can't delete default locale"
      return false
    end
  end

  def delete_instance_keys
    Translation.for_instance(instance_id).where(locale: code).delete_all
  end
end
