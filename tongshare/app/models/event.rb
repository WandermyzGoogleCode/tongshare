require 'gcal4ruby'

class Event < ActiveRecord::Base
  attr_accessible :name, :begin, :end, :location, :extra_info, :rrule
  
  belongs_to :creator, :class_name => "User"
  has_many :acceptances, :dependent => :destroy
  has_many :sharings, :foreign_key => "event_id", :dependent => :destroy
  has_many :reminders, :foreign_key => "event_id", :dependent => :destroy
  has_many :instances, :foreign_key => "event_id", :dependent => :destroy

  #TODO validates
  #
  def generate_instance
    #TODO check if instances present
    rec = GCal4Ruby::Recurrence.new
    rec.load('RRULE:' + self.rrule)
    #TODO finish all freq
    if rec.frequency == 'WEEKLY'
      now = self.begin
      count = 0
      while 1
        if rec.day[now.wday]
          #:name => self.name, :location => self.location, :extra_info => self.extra_info,
          i = self.instances.build(:begin => now, :end => self.end + (now - self.begin), :override => false, :index => count)
          i.save
          count += 1
        end
        now += 1.day
        if rec.count and count >= rec.count.to_i
          break
        end
        if rec.repeat_until and now >= rec.repeat_until
          break
        end
      end
      puts 'instance generated:' + self.instances.size.to_s
    end
  end
end
