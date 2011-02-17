require 'thuauth'
require 'uri'
require 'net/http'
require 'digest/sha2'
require 'base64'
require 'pp'

class ThuauthController < ApplicationController
  SECRET = "this is a secret" # TODO put this config outside source file
  TONGSHARE_AUTH_CONFIRM_URL = "http://localhost:3000/auth/confirm"
  TONGSHARE_DOMAIN = "localhost"
  TONGSHARE_PORT = 3000
  TONGSHARE_AUTH_CONFIRM_PATH = "/auth/confirm"

  def auth_with_xls_and_get_name
#    Thread.exclusive do
      @password = params[:password]
      @username = params[:username]
      @redirect_to = params[:redirect_to]
      if (@password && @username)
        authenticated, name = ThuAuth.do_auth(@username, @password)
        name ||= ""
        if (authenticated)
          Dir.chdir(AuthConstant::GETXLS_PATH)
          data = Base64.encode64(IO.read("output.xls", File.size("output.xls"), 0))
          hash_value = (Digest::SHA2.new << @username + name + SECRET).to_s
          response = Net::HTTP.post_form(URI.parse(TONGSHARE_AUTH_CONFIRM_URL),
            {:username => @username, :name => name, :hash => hash_value, :data => data}
          )
#          headers = {'Content-Type' => 'application/octet-stream'}
#          http = Net::HTTP.new(TONGSHARE_DOMAIN, TONGSHARE_PORT)
#          response = http.post(TONGSHARE_AUTH_CONFIRM_PATH +
#              sprintf("?username=%s&name=%s&hash=%s", @username, URI.escape(name), hash_value),
#            data, headers)
          pp response # TODO REVERT TEST
          pp response.body
          
          if response.body.match /accepted/
            redirect_to @redirect_to
          else
            flash[:alert] = "Confirmation not accepted"
            @display = response.body
          end
        else
          flash[:alert] = "Authentication failed"
        end
      end
#    end
  end
end
