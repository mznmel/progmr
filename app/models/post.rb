class Post < ActiveRecord::Base
  attr_accessible :content, :title, :url

  belongs_to :user
  belongs_to :major_tag, :class_name => "Tag"
  belongs_to :minor_tag, :class_name => "Tag"
  belongs_to :extra_tag, :class_name => "Tag"

  has_many :post_votes
  has_many :voters, :through => :post_votes, :source => :user

  has_many :comments

  validates :title, :presence => true
  validates :content, :presence => true
  validates :major_tag, :presence => true
  validates :url, :format => URI::regexp(%w(http https)), :allow_blank => true

  def prepare_tags(major_tag_name, minor_tag_name = nil, extra_tag_name = nil)
    major = Tag.find_or_create_by_name(major_tag_name) if not major_tag_name.blank?
    minor = Tag.find_or_create_by_name(minor_tag_name) if not minor_tag_name.blank?
    extra = Tag.find_or_create_by_name(extra_tag_name) if not extra_tag_name.blank?
    self.major_tag = major if major
    self.minor_tag = minor if minor
    self.extra_tag = extra if extra
  end
end
