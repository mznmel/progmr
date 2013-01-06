class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :content
      t.integer :votes

      t.belongs_to :user
      t.belongs_to :post

      t.string :ancestry

      t.timestamps
    end

    add_index :comments, :user_id
    add_index :comments, :post_id
    add_index :comments, :votes
    add_index :comments, :ancestry
  end
end
