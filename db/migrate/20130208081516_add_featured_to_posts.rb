class AddFeaturedToPosts < ActiveRecord::Migration
  def change
    change_table :posts do |t|
      t.boolean :featured, :default => false
    end
  end
end
