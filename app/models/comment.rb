class Comment < ActiveRecord::Base
  attr_accessible :content, :post_id, :parent_id
  belongs_to :post
  belongs_to :user

  validates :post, :presence => true
  validates :content, :presence => true, :length => {:minimum => 3}

  after_create :increase_comments_count
  after_destroy :decrease_comments_count

  has_ancestry

  def increase_comments_count
    self.post.increment!(:comments_count)
  end


  def decrease_comments_count
    self.post.decrement!(:comments_count)
  end
end
