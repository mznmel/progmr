class CreatePostsVotes < ActiveRecord::Migration
  def change
    create_table :post_votes do |t|
      t.boolean :vote
      t.belongs_to :user
      t.belongs_to :post

      t.timestamps
    end

    add_index :post_votes, [:user_id, :post_id], :unique => true
  end
end
