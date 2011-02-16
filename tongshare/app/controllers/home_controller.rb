#by Wander
#home for the whole site. Currently it is used for testing

class HomeController < ApplicationController
  def index



    if user_signed_in?
      flash[:notice] = notice
      flash[:alert] = alert
      redirect_to :controller => "events", :range => :day, :offset => 0
    else
      
    end

        
  end

end
