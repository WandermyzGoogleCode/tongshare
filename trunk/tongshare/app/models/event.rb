require 'gcal4ruby'

class Event < ActiveRecord::Base

  MAX_INSTANCE_COUNT = 64
  attr_accessible :name, :begin, :end, :location, :extra_info, :rrule
  
  belongs_to :creator, :class_name => "User"
  has_many :acceptances, :foreign_key => "event_id", :dependent => :destroy
  has_many :sharings, :foreign_key => "event_id", :dependent => :destroy
  has_many :reminders, :foreign_key => "event_id", :dependent => :destroy
  has_many :instances, :foreign_key => "event_id", :dependent => :destroy

  #TODO validates
  validates :name, :begin, :presence => true
  #
  #
  def save
    ret = super
    return false if !ret
    #TODO review of when to call save?
    #TODO edit each for better performance?
    drop_instance
    generate_instance
  end

  def update_attributes(vars = {})
    super
    #TODO edit each for better performance?
    drop_instance
    generate_instance
  end

  #TODO untested
  #TODO group?
  def add_sharing(current_user_id, extra_info, user_ids, group_ids = '')
    s = self.sharings.new(:shared_from => current_user_id, :extra_info => extra_info)
    s.save
    ids = user_ids.split(%r{[,;]\s*})
    ids.each do |i|
      u = s.user_sharing.new(:user_id => i.to_i)
      u.save
    end
  end

  def query_instance(time_begin, time_end)
    Instance.where("event_id = ? AND begin >= ? AND end <= ?", self.id, time_begin, time_end).order("begin")
  end

  #TODO untested
  def decide_by_user(user_id, acceptance = ACCEPTANCE_TRUE)
    accs = self.acceptances.where("user_id = ? AND event_id = ?", user_id, self.id)
    if accs
      assert accs.size == 1
      accs[0].decision = acceptance
      accs[0].save
    else
      acc = self.acceptances.new(:user_id => user_id, :decision => acceptance)
      acc.save
    end
  end

  
  protected
 
  def drop_instance
    if self.instances
      self.instances.each do |i|
        i.destroy
      end
    end
  end
  
  def generate_instance
    #TODO check if instances present
    if !self.rrule || self.rrule == ""
      i = self.instances.build(
        :override => nil,
        :name => self.name,
        :location => self.location,
        :extra_info => self.extra_info,
        :begin => self.begin,
        :end => self.end
        )
      i.save
    else
      rec = GCal4Ruby::Recurrence.new
      rec.load('RRULE:' + self.rrule)
      if rec.frequency == 'DAILY'
        #TODO
      elsif rec.frequency == 'WEEKLY'
        now = self.begin
        count = 0
        interval = 0
        interval = rec.interval - 1 if rec.interval > 1
        while 1
          if rec.day[now.wday]
            #
            i = self.instances.build(
              :name => self.name, 
              :location => self.location, 
              :extra_info => self.extra_info,
              :begin => now,
              :end => self.end + (now - self.begin),
              :override => false,
              :index => count
            )
            i.save
            count += 1
          end
          now += 1.day
          if now.sunday?
            now += (interval * 7).day
          end

          if count >= MAX_INSTANCE_COUNT
            break
          end

          if rec.count and count >= rec.count.to_i
            break
          end
          
          if rec.repeat_until and now >= rec.repeat_until
            break
          end
        end
        puts 'instance generated:' + self.instances.size.to_s
      elsif rec.frequency == 'MONTHLY'
        #TODO
      elsif rec.frequency == 'YEARLY'
        #TODO
      else
        puts "event id = #{self.id}: unknown frequency: #{rec.frequency}!"
      end
    end
  end
  
end
