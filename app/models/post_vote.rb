class PostVote < ActiveRecord::Base
  belongs_to :user
  belongs_to :post

  after_create :increase_karma_and_votes, :if => :upVote?
  after_create :decrease_karma_and_votes, :unless => :upVote?

  before_destroy :decrease_karma_and_votes, :if => :upVote?
  before_destroy :increase_karma_and_votes, :unless => :upVote?

  def upVote?
    return (self.vote == true || self.vote == 't' || self.vote == "true")
  end

  def increase_karma_and_votes
    self.post.user.increment!(:posts_karma)
    self.post.increment!(:votes)
  end

  def decrease_karma_and_votes
    self.post.user.decrement!(:posts_karma)
    self.post.decrement!(:votes)
  end
end
