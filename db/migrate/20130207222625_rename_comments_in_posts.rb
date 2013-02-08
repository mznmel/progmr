class RenameCommentsInPosts < ActiveRecord::Migration
  def change
    change_table :posts do |t|
      t.rename :comments, :comments_count
    end
  end
end
