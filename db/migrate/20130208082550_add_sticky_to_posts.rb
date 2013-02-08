class AddStickyToPosts < ActiveRecord::Migration
  def change
    change_table :posts do |t|
      t.boolean :sticky, :default => false
    end
  end
end