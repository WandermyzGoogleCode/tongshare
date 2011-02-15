class RegistrationsExtendedController < Devise::RegistrationsController
include RegistrationsExtendedHelper
  def new
    super
    authorize! :create, resource
  end

  def create

    build_resource

    #add user identifiers
    resource.user_identifier.build \
      :login_type => UserIdentifier::TYPE_EMPLOYEE_NO,
      :login_value => params[:employee_no]

    if !params[:user][:email].nil? && !params[:user][:email].empty?
      resource.user_identifier.build \
        :login_type => UserIdentifier::TYPE_EMAIL,
        :login_value => params[:user][:email]
    end

    if !params[:mobile].nil? && !params[:mobile].empty?
      resource.user_identifier.build \
        :login_type => UserIdentifier::TYPE_MOBILE,
        :login_value => params[:mobile]
    end

    #go around for email validation:
    #devise will validate email's presence and uniqueness, however we allow users register with empty email
    #to pass the validation of devise, we create a random email with pattern sth@null.tongshare.com to represent empty email
    #duplicate: theoretically it is almost impossible.
    if params[:user][:email].nil? || params[:user][:email].empty?
      username = UUIDTools::UUID.random_create
      params[:user][:email] = "#{username}@#{User::NIL_EMAIL_ALIAS_DOMAIN}"
      resource.email = params[:user][:email]
    end

    authorize! :create, resource

    #skip email verify always
    resource.skip_confirmation!

    #do what devise does
    if resource.save
      set_flash_message :notice, :signed_up
      sign_in_and_redirect(resource_name, resource)
    else
      clean_up_passwords(resource)
      render_with_scope :new
    end

  end

  def edit
    #TODO
    super
    authorize! :update
  end

  def update
    #TODO
    super
    authorize! :update
  end

  def destroy
    #TODO
    super
    authorize :destroy
  end
end
