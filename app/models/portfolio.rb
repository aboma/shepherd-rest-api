# == Schema Information
#
# Table name: portfolios
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  description :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

class Portfolio < ActiveRecord::Base
  authenticates_with_sorcery!
  
  attr_accessible :name, :description

  validates_presence_of :name
  validates_uniqueness_of :name
  
  class << self
    def not_deleted
      where(:deleted_at => nil)
    end
  end
  
  
  protected
  def mark_deleted
    self.deleted_at = Time.now
  end
  
  def mark_deleted!
    mark_deleted
    self.save
  end
end
