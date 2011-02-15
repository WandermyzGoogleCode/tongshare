module EventsHelper
  require 'thucourse'
  require 'gcal4ruby/recurrence'
  require 'time'

   # Please check these time settings. Are they correct?
  COURSE_BEGINES = ["8:00", "9:50", "13:30", "15:20", "17:05", "19:20"]
  COURSE_ENDS = ["9:35", "11:25", "15:05", "16:55", "18:40", "21:05"]

  # TODO This should be configured for each semester so it's better
  # to be setted in a separate config file.
  # Note! This day is Sunday instead of Monday(since Monday is +1)
  FIRST_DAY_IN_SEMESTER = "2011-2-20"

  # Convert a course_class to events
  # Note that a course_class may include multiple classes per week,
  # therefore multiple events will be generated according to current settings.
  def class2event(course_class)
    event = Event.new(:name => course_class.name, :extra_info => course_class.extra_info, :location => course_class.location)
    week_day = course_class.week_day
    day_time = course_class.day_time-1 # from 1..6 to 0..5
    # Note that week_day = 7 for Sunday so first Sunday class will be 6 days after the first Monday
    event.begin = Time.parse(FIRST_DAY_IN_SEMESTER + " " + COURSE_BEGINES[day_time]) + week_day.days
    event.end = Time.parse(FIRST_DAY_IN_SEMESTER + " " + COURSE_ENDS[day_time]) + week_day.days
    rrule = GCal4Ruby::Recurrence.new
    rrule.frequency = GCal4Ruby::Recurrence::WEEKLY_FREQUENCE
    rrule.set_day(week_day)
    rrule.count = 16
    if (course_class.week_modifier)
      case course_class.week_modifier
      when CourseClass::EVEN_WEEK
        rrule.count = 8
        rrule.interval = 2
        event.begin += 7.days
        event.end += 7.days
      when CourseClass::ODD_WEEK
        rrule.count = 8
        rrule.interval = 2
      when CourseClass::EARLIER_EIGHT
        rrule.count = 8
      when CourseClass::LATER_EIGHT
        rrule.count = 8
        event.begin += (7*8).days
        event.end += (7*8).days
      end
    end
    event.rrule = rrule.rrule
    return event
  end

  #go around time zone bug in calendar_date_selector
  def time_ruby2selector(event)
    event.begin = event.begin + 8.hours unless event.begin.blank?
    event.end = event.end + 8.hours unless event.end.blank?
  end

  def time_selector2ruby(event)
    event.begin = event.begin - 8.hours unless event.begin.blank?
    event.end = event.end - 8.hours unless event.end.blank?
  end

  def query_own_instance(time_begin, time_end, creator_id = current_user.id)
    #TODO check event changed
    Instance.where("creator_id = ? AND begin >= ? AND end <= ?", creator_id, time_begin, time_end).order("begin")
  end

  def query_own_event(limit_from, limit_num, creator_id = current_user.id)
    Event.where("creator_id = ?", creator_id).limit(limit_num).offset(limit_from).order("begin")
  end

  #TODO untested
  #TODO group?
  #user_sharing (uid, pri) -> sharing -> event -> instance (time begin/end)
  class SQLConstant
    SELECT_INSTANCE = "instances.*"
    SELECT_EVENT = "events.*"
    JOINS_BASE = 'INNER JOIN sharings ON sharings.id = user_sharings.sharing_id ' +
            'INNER JOIN events ON sharings.event_id = events.id ' +
            'LEFT OUTER JOIN acceptances ON acceptances.event_id = events.id AND acceptances.user_id = user_sharings.user_id '
    JOINS_INSTANCE = 'INNER JOIN instances ON instances.event_id = events.id'
    WHERE_USER_ID = "user_sharings.user_id = ?"
    WHERE_PRIORITY = "user_sharings.priority = ?"
    WHERE_TIME = "instances.begin >= ? AND instances.end <= ?"
    WHERE_DECISION = "acceptances.decision = ?"
    WHERE_DECISION_UNDECIDED = "acceptances.decision IS NULL"
    WHERE_AND = ' AND '
  end

  def build_where(*w)
    w.join(SQLConstant::WHERE_AND)
  end

  # !readonly value returned
  def query_all_accepted_instance(time_begin, time_end, user_id = current_user.id)
    query_sharing_accepted_instance(time_begin, time_end, user_id) + query_own_instance(time_begin, time_end, user_id)
  end

  # !readonly value returned
  def query_sharing_accepted_instance(time_begin, time_end, user_id = current_user.id)
    UserSharing.
      select(SQLConstant::SELECT_INSTANCE).
      joins(SQLConstant::JOINS_BASE + SQLConstant::JOINS_INSTANCE).
      where(
        build_where(SQLConstant::WHERE_USER_ID, SQLConstant::WHERE_DECISION, SQLConstant::WHERE_TIME),
        user_id,
        Acceptance::DECISION_ACCEPTED,
        time_begin, time_end)
  end

  # !readonly value returned
  def query_sharing_event(priority = UserSharing::PRIORITY_INVITE, decision = Acceptance::DECISION_UNDECIDED, user_id = current_user.id)
    if decision == Acceptance::DECISION_UNDECIDED
      UserSharing.
        select(SQLConstant::SELECT_EVENT).
        joins(SQLConstant::JOINS_BASE).
        where(
          build_where(SQLConstant::WHERE_USER_ID, SQLConstant::WHERE_DECISION_UNDECIDED, SQLConstant::WHERE_PRIORITY),
          user_id,
          priority)
    else
      UserSharing.
        select(SQLConstant::SELECT_EVENT).
        joins(SQLConstant::JOINS_BASE).
        where(
          build_where(SQLConstant::WHERE_USER_ID, SQLConstant::WHERE_DECISION, SQLConstant::WHERE_PRIORITY),
          user_id,
          decision,
          priority)
    end
  end
  
end
