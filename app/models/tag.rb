class Tag < ActiveRecord::Base
  attr_accessible :description, :name

  validates :name, :presence => true,
            :length => {:maximum => 25}
end
