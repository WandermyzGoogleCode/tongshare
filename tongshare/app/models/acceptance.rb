# decision is in {0, 1} where 0 is reject and 1 is accept
class Acceptance < ActiveRecord::Base
  DECISION_ACCEPTED = true
  DECISION_DENY = false
  DECISION_UNDECIDED = nil
  DECISION_DEFAULT = :fake
  
  attr_accessible :user_id, :decision
  
  belongs_to :event
  belongs_to :user
  
  validates :user_id, :event_id, :decision, :presence => true
  validates_inclusion_of :decision, :in => [DECISION_ACCEPTED, DECISION_DENY]

  validate do |accept|
    errors.add :user_id, :already_exists if Acceptance.where("event_id = ? AND user_id = ?". accept.event_id, accept.user_id).exists?
  end
end
