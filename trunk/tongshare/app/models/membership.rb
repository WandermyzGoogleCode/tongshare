# Currently column power is in {0, 1} where 0 is admin and 1 is normal member.
# Later, more power levels can be added
class Membership < ActiveRecord::Base
  # currently power < 2. In fact, the bigger a power is, the less permission a user has
  POWER_UPPER_BOUND = 2 
  
  belongs_to :group
  belongs_to :user
  
  validates :power, :group_id, :user_id, :presence => true
  validates_numericality_of :power, :only_integer => true, :less_than => POWER_UPPER_BOUND
end
