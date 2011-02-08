require 'gcal4ruby'
include GCal4Ruby
class TempController < ApplicationController
  def view
    @cals = []
    @events = []
    user = params[:user]
    pass = params[:pass]
    if user == nil or pass == nil
      return
    end
    service = Service.new
    service.authenticate(user, pass)
    calendars = service.calendars
    @cals = []
    calendars.each do |cal|
      @cals << cal.title
    end
    @events = calendars[0].events()
  end

end
