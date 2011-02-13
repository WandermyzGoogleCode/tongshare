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
  #TODO group?
  #user_sharing (uid, pri) -> sharing -> event -> instance (time begin/end)
  def query_sharing_instance(time_begin, time_end, priority = PRIORITY_INVITE, acceptance = ACCEPTANCE_DEFAULT, user_id = current_user.id)
    #
    if acceptance == ACCEPTANCE_DEFAULT
      where = "user_sharings.user_id = ? " +
              "AND user_sharings.priority = ? " +
              "AND instances.begin >= ? " +
              "AND instances.end <= ? "
      UserSharing.
        select("instances.*").
        joins('INNER JOIN sharings ON sharings.id = user_sharings.sharing_id').
        joins('INNER JOIN events ON sharings.event_id = events.id').
        joins('LEFT OUTER JOIN acceptances ON acceptances.event_id = events.id AND acceptances.user_id = user_sharings.user_id').
        joins('INNER JOIN instances ON instances.event_id = events.id').
        where(where,
              user_id,
              priority,
              time_begin,
              time_end)
    else
      where = "user_sharings.user_id = ? " +
              "AND user_sharings.priority = ? " +
              "AND instances.begin >= ? " +
              "AND instances.end <= ? " +
              "AND acceptances.decision = ?"
      UserSharing.
        select("instances.*").
        joins('INNER JOIN sharings ON sharings.id = user_sharings.sharing_id').
        joins('INNER JOIN events ON sharings.event_id = events.id').
        joins('LEFT OUTER JOIN acceptances ON acceptances.event_id = events.id AND acceptances.user_id = user_sharings.user_id').
        joins('INNER JOIN instances ON instances.event_id = events.id').
        where(where,
              user_id,
              priority,
              time_begin,
              time_end,
              acceptance)
    end
  end
end
