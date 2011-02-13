# Currently, column priority is in {0, 1} where 0 is invitation and 1 is
# recommendation. Later, more priority levels may be added. 
class UserSharing < ActiveRecord::Base
  PRIORITY_INVITE = 0
  PRIORITY_RECOMMENDATION = 1

  belongs_to :sharing
  belongs_to :user
  
  validates :user_id, :sharing_id, :priority, :presence => true
  validates_numericality_of :priority, :only_integer => true, :less_than => Sharing::MAX_PRIORITY

  def accept?
    acc = Acceptance.where("event_id = ? AND user_id = ?", self.sharing.event_id, self.user_id)
    acc[0].decision if acc
  end


end
