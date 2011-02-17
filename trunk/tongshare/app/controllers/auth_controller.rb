require 'base64'
require 'digest/sha2'

class AuthController < ApplicationController
  skip_before_filter :verify_authenticity_token
  
  SECRET = "this is a secret" # should be the same with ThuAuth

  def confirm
    name = params[:name]
    username = params[:username] # 学号
    hash_value = params[:hash]
    data = Base64.decode64(params[:data])
    @output = "params not valid"
    return unless name && username && hash_value && data
    my_hash = (Digest::SHA2.new << (username + name + SECRET)).to_s
    @output = "hash not valid"
    return unless my_hash == hash_value
    @output = "accepted"

    xls2events data, current_user.id
  end
end
