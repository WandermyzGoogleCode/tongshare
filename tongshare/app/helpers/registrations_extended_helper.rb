module RegistrationsExtendedHelper
  #check if a given email is null alias (xxx@null.tongshare.com)
  def nil_email_alias?(email)
    not email.match(/.+@#{User::NIL_EMAIL_ALIAS_DOMAIN}/).nil?
  end

  def more_login_used?
    return false if params.nil?
    return true if \
      !params[:user].nil? \
        && !params[:user][:email].nil? \
        && !params[:user][:email].empty? \
        && !nil_email_alias?(params[:user][:email])
    
    return true if !params[:mobile].nil? && !params[:mobile].empty?
    return false
  end

  def login_invalid?(field)
    return false if (!defined? resource || resource.valid?)

    login_errors = resource.errors[:login_value]
    return false if login_errors.nil?

    #logger.debug login_errors[0]
    #logger.debug(I18n.t "activerecord.errors.models.user_identifier.attributes.login_value.#{field}_invalid")
    login_errors.include?(I18n.t "activerecord.errors.models.user_identifier.attributes.login_value.#{field}_invalid")
  end

  def label_for_login(field)
    div_tag = login_invalid?(field) ? "<div class=\"field_with_errors\">".html_safe : "<div>"
    field_name = I18n.t "activerecord.attributes.user_identifier.#{field.to_s}"
    
    content = <<HTML
    #{div_tag}
      <label for="#{field}">#{field_name}</label>
    </div>
HTML
    content.html_safe
  end

  def text_field_for_login(field)
    div_tag = login_invalid?(field) ? "<div class=\"field_with_errors\">".html_safe : "<div>"
    field_tag = text_field_tag field, params[field], :max_length => UserIdentifier::MAX_VALUE_LENGTH

    content = <<HTML
    #{div_tag}
      #{field_tag}
    </div>
HTML
    content.html_safe
  end
end
