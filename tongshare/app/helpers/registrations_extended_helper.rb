module RegistrationsExtendedHelper
  #check if a given email is null alias (xxx@null.tongshare.com)
  def nil_email_alias?(email)
    not email.match(/.+@#{User::NIL_EMAIL_ALIAS_DOMAIN}/).nil?
  end
end
