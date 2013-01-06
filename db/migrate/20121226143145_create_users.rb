class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :username
      t.string :password_digest
      t.integer :posts_karma, :default => 0
      t.integer :comments_karma, :default => 0

      t.timestamps
    end

    add_index :users, :email, :unique => true
    add_index :users, :username, :unique => true
  end
end
