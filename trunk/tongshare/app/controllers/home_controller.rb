#by Wander
#home for the whole site. Currently it is used for testing

class HomeController < ApplicationController
  before_filter :authenticate_user!

  def index
    @test = UUIDTools::UUID.random_create

    @user = User.new
    @user.user_identifier.build
  end

end
