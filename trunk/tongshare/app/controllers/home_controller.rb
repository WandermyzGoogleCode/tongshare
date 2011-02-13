#by Wander
#home for the whole site. Currently it is used for testing

class HomeController < ApplicationController
  def index



    if user_signed_in?
      flash[:notice] = notice
      flash[:alert] = alert
      redirect_to events_url
    else
      
    end

        
  end

end
