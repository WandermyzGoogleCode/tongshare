# decision is in {0, 1} where 0 is reject and 1 is accept
class Acceptance < ActiveRecord::Base
  DECISION_ACCEPTED = true
  DECISION_DENY = false
  DECISION_UNDECIDED = nil
  DECISION_DEFAULT = :fake
  
  belongs_to :event
  belongs_to :user
  
  validates :user_id, :event_id, :decision, :presence => true
  
  # decision must be either 0(reject) or 1(accept)
  validates_numericality_of :decision, :only_integer => true, :less_than => 2
end
