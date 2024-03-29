class Instance < ActiveRecord::Base
  include EventsHelper

  attr_accessible :name, :begin, :end, :location, :extra_info, :event_id, :index, :override, :creator_id
  attr_accessible :event
  belongs_to :event
  has_many :feedback, :dependent => :destroy
  #validates :event_id, :creator_id, :presence => true

  def warning_count
    Feedback.where("instance_id=? AND value=?",
        self.id, Feedback::WARNING).count
  end

  def average_score_with_reliability
    feedbacks = Feedback.where("instance_id=? AND value like ?",
      self.id, Feedback::SCORE+".%").to_a
    cnt = 0
    sum = 0
    for feedback in feedbacks
      m = feedback.value.match Feedback::SCORE_REGEX
      if (m)
        sum += m[1].to_i
        cnt += 1
      end
    end
    reliability = cnt.to_f / get_attendees(self.event).count
    return [sum.to_f / [cnt, 1].max, reliability]
  end
end
