require 'gcal4ruby'

class Event < ActiveRecord::Base

  MAX_INSTANCE_COUNT = 64
  # In order to make Event.new(:creator_id => creator_id) work, attr_accessible :creator_id
  # seems to be necessary!
  attr_accessible :name, :begin, :end, :location, :extra_info, :rrule, :creator_id
  attr_accessible :rrule_interval, :rrule_frequency, :rrule_days, :rrule_count

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
    #generate rrule
    logger.debug self.recurrence.to_yaml
    self.rrule = self.recurrence.rrule
    logger.debug self.rrule.to_yaml

    ret = super

    logger.debug errors.to_yaml

    return false if !ret
    #TODO review of when to call save?
    #TODO edit each for better performance?
    drop_instance
    generate_instance
    #TODO: LC: you should return true/false. Once fail to generate, you need to rollback the newly created event.
    return true
  end

#  def update_attributes(vars = {})
#    #"super" will call "save", so no more for rrule
#
#    ret = super
#    return false if !ret
#    #TODO edit each for better performance?
#    #drop_instance
#    #generate_instance
#    #modified by Wander: do not do these two operations because update_attributes calls "save"
#  end

  #TODO untested
  #TODO group?
  def add_sharing(current_user_id, extra_info, user_ids, group_ids = '')
    # I think this won't work since sharing has no attr_accessor!
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

  #virtual fields for recurrence logic
  #these fields will simplify and unify new/edit in controllers
  #TODO: validates
  def recurrence
    if !defined? @recurrence
      @recurrence = GCal4Ruby::Recurrence.new
      @recurrence.from_rrule(self.rrule) unless self.rrule.blank?
    end

    @recurrence
  end

  def rrule_frequency
    ret = self.recurrence.frequency
    ret ||= GCal4Ruby::Recurrence::NONE_FREQUENCY
    ret
  end

  def rrule_frequency=(f)
    self.recurrence.frequency = f
  end

  def rrule_interval
    ret = self.recurrence.interval
    ret ||= 1
    ret
  end

  def rrule_interval=(i)
    self.recurrence.interval = i.to_i
  end

  def rrule_days
    self.recurrence.get_days
  end

  def rrule_days=(days)
    ret = []
    days.each do |d|
      ret << d.to_i unless d.blank?
    end
    self.recurrence.set_days(ret)
  end

  def rrule_count
    self.recurrence.count
  end

  def rrule_count=(count)
    self.recurrence.count = count.to_i
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
        :end => self.end,
        :creator_id => self.creator_id
        )
      i.save
    else
      #rec = GCal4Ruby::Recurrence.new
      #rec.from_rrule(self.rrule) # rec.load('RRULE:' + self.rrule) will encounter bug since self.rrule may begin with 'RRULE:'
      
      #modified by Wander
      rec = self.recurrence

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
              :index => count,
              :creator_id => self.creator_id
            )
            i.save
            count += 1
          end
          now += 1.day
          if now.wday == 0 # now.sunday? is too new for ruby1.8.7
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
