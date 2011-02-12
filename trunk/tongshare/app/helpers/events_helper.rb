module EventsHelper
  def query_instance(time_begin, time_end, creator_id = current_user.id)
    #TODO check event changed
    Instance.where("creator_id = ? AND begin >= ? AND end <= ?", creator_id, time_begin, time_end).order("begin")
  end

  def query_event(limit_from, limit_num, creator_id = current_user.id)
    Event.where("creator_id = ?", creator_id).limit(limit_num).offset(limit_from).order("begin")
  end

end
