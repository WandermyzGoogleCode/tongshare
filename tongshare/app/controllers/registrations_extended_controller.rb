class RegistrationsExtendedController < Devise::RegistrationsController
  def new
    super
  end

  def create

    build_resource

    begin
      #add user identifiers
      resource.user_identifier.build \
        :type => UserIdentifier::TYPE_COMPANY_ID,
        :value => params[:company_id]
      
      if !params[:user][:email].empty?
        resource.user_identifier.build \
          :type => UserIdentifier::TYPE_EMAIL,
          :value => params[:user][:email]
      end

      if !params[:mobile].empty?
        resource.user_identifier.build \
          :type => UserIdentifier::TYPE_MOBILE,
          :value => params[:mobile]
      end

      #go around for email validation:
      #devise will validate email's presence and uniqueness, however we allow users register with empty email
      #to pass the validation of devise, we create a random email with pattern sth@null.tongshare.com to represent empty email
      #duplicate: theoretically it is almost impossible.
      if params[:user][:email].empty?
        username = UUIDTools::UUID.random_create
        params[:user][:email] = "#{username}@#{User::NIL_EMAIL_ALIAS_DOMAIN}"
        resource.email = params[:user][:email]
      end

      #do what devise does
      resource.save!
      set_flash_message :notice, :signed_up
      sign_in_and_redirect(resource_name, resource)
    rescue Exception => e
      logger.error("Exception: #{e.message}")
      clean_up_passwords(resource)
      render_with_scope :new
    end

  end

  def edit
    super
  end

  def update
    super
  end

  def destroy
    super
  end
end
