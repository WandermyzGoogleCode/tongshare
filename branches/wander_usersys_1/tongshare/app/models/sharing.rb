class Sharing < ActiveRecord::Base
  # currently, priority is in {0, 1} for invitate and recommend respectively
  MAX_PRIORITY = 2
  
  belongs_to :event
  has_many :user_sharing, :dependent => :destroy
  has_many :group_sharing, :dependent => :destroy
end
