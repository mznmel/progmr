class Comment < ActiveRecord::Base
  attr_accessible :content, :post_id, :parent_id
  belongs_to :post
  belongs_to :user

  validates :post, :presence => true
  validates :content, :presence => true, :length => {:minimum => 3}

  has_ancestry
end
