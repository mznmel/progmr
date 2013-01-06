class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.string :url
      t.text :content
      t.integer :comments, :default => 0

      t.belongs_to :user
      t.belongs_to :major_tag
      t.belongs_to :minor_tag
      t.belongs_to :extra_tag

      t.integer :votes, :default => 0

      t.timestamps
    end

    add_index :posts, :user_id
    add_index :posts, :major_tag_id
    add_index :posts, :minor_tag_id
    add_index :posts, :extra_tag_id
    add_index :posts, :votes
  end
end
