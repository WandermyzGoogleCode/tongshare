require 'gcal4ruby'

#include GCal4Ruby
include GcalHelper
class TempController < ApplicationController
  
  def cal
    #test for query= =
    time_begin = Time.utc(2011, 1, 1)
    time_end = Time.utc(2011, 3, 1)
    is =  Event.query(time_begin, time_end)
    puts is.size

    ##
    create_calendar
  end

  def view
    @cals = []
    @events = []
    #user = params[:user]
    #pass = params[:pass]
    #if user == nil or pass == nil
    #  return
    #end
    if not user_signed_in?
      redirect_to "/users/sign_up"
      return
    end
    if not current_user.google
      redirect_to "/oauth_consumers/google"
      return
    end
    service = GCal4Ruby::Service.new({:GData4RubyService => :OAuthService})
    #service = GData4Ruby::OAuthService.new
    
    service.authenticate(:access_token => current_user.google.client)

    #
    calendars = service.calendars
    @cals = []
    calendars.each do |cal|
      @cals << cal.title
    end
    @events = calendars[0].events()
  end

end
