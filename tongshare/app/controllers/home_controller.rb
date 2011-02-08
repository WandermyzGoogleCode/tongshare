#by Wander
#home for the whole site. Currently it is used for testing

class HomeController < ApplicationController
  before_filter :authenticate_user!

  def index
  end

end
