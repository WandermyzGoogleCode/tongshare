module AuthHelper
  AUTH_SERVER_PATH = "http://localhost:3001/thuauth/auth_with_xls_and_get_name/"

  def auth_path(username, redirect_to)
    AUTH_SERVER_PATH + "?username=#{URI.escape(username)}&redirect_to=#{URI.escape(redirect_to)}"
  end
end
