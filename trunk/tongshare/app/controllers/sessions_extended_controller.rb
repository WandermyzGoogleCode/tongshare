class SessionsExtendedController < Devise::SessionsController
  def new
    super
  end

  def create
    #find user_id for devise
    user_id_rec = UserIdentifier.find \
      :first,
      :conditions => ["login_type = ? AND login_value = ?",
                      params[:login_type],
                      params[:login_value]
      ]

    #logger.debug "Result: #{user_id_rec.to_yaml}"

    if user_id_rec.nil?
      params[:user][:id] = -1
    else
      params[:user][:id] = user_id_rec.user_id
    end

    logger.debug params.to_yaml

    super
  end

end
