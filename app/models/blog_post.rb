class BlogPost < ActiveRecord::Base

  belongs_to :blog_instance
  belongs_to :user # user who created this post

  extend FriendlyId
  friendly_id :title, use: :slugged

  validates_presence_of :blog_instance, :user, :title, :content

  mount_uploader :header, HeroImageUploader
  mount_uploader :author_avatar, SimpleAvatarUploader

  scope :by_date, -> { order('COALESCE(published_at, created_at) desc') }
  scope :published, -> { where("published_at < ? OR published_at IS NULL", Time.zone.now ) }
  

  def previous_blog_post
    @previous_blog_post ||= blog_instance.blog_posts.where('COALESCE(published_at, created_at) < ?', created_at).first
  end

  def next_blog_post
    @next_blog_post ||= blog_instance.blog_posts.where('COALESCE(published_at, created_at) > ?', created_at).last
  end

  def slug_changed?
    return false if title.blank? && slug.blank?
    title.parameterize != slug
  end

  def should_generate_new_friendly_id?
    slug.blank?
  end

end
