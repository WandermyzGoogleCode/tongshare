module EventsHelper
  def query_own_instance(time_begin, time_end, creator_id = current_user.id)
    #TODO check event changed
    Instance.where("creator_id = ? AND begin >= ? AND end <= ?", creator_id, time_begin, time_end).order("begin")
  end

  def query_own_event(limit_from, limit_num, creator_id = current_user.id)
    Event.where("creator_id = ?", creator_id).limit(limit_num).offset(limit_from).order("begin")
  end

  PRIORITY_INVITE = 0
  PRIORITY_RECOMMENDATION = 1
  ACCEPTANCE_DEFAULT = :fake
  ACCEPTANCE_TRUE = true
  ACCEPTANCE_FALSE = false
  ACCEPTANCE_UNDECIDED = nil
  
  #TODO untested
  
  def query_sharing_instance(time_begin, time_end, priority = PRIORITY_INVITE, acceptance = ACCEPTANCE_DEFAULT, user_id = current_user.id)
    user_sharings = UserSharing.where("user_id = ? AND priority = ?", user_id, priority)
    if acceptance != ACCEPTANCE_DEFAULT
      user_sharings.keep_if{|u| u.accept? == acceptance }
    end
    events = user_sharings.map { |u| u.sharing.event }
    ret = []
    events.each do |e|
      ret += e.query_instance(time_begin, time_end)
    end
    ret
  end

end
