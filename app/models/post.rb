class Post < ActiveRecord::Base
  attr_accessible :comments, :content, :slug, :title, :user_id, :viewer
end
