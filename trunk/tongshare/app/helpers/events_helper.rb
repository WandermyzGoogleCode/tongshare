module EventsHelper
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
