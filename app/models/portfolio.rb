class Portfolio < ActiveRecord::Base
  authenticates_with_sorcery!
   
  attr_accessible :name, :description

  validates_presence_of :name
  validates_uniqueness_of :name
end