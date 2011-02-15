class EventsController < ApplicationController
  include EventsHelper

  before_filter :authenticate_user!

  # GET /events
  # GET /events.xml
  def index
    @events = Event.find_all_by_creator_id current_user.id
    authorize! :index, Event

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
    end
  end

  # GET /events/1
  # GET /events/1.xml
  def show
    @event = Event.find(params[:id])
    authorize! :show, @event
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/new
  # GET /events/new.xml
  def new
    @event = Event.new
    @event.begin = Time.now
    @event.end = Time.now + 30.minutes
    time_ruby2selector(@event)

    @event.rrule_days = [Date.today.wday]
    @event.rrule_count = 16  #TODO: how to set default value?

    @event.creator_id = current_user.id
    authorize! :new, @event

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
    authorize! :edit, @event
    
    time_ruby2selector(@event)
  end

  # POST /events
  # POST /events.xml
  def create
    @event = Event.new(params[:event])
    time_selector2ruby(@event)

    @event.creator_id = current_user.id
    authorize! :create, @event
    
    ret = @event.save
    respond_to do |format|
      if ret
        format.html { redirect_to(@event, :notice => I18n.t('tongshare.event.created', :name => @event.name)) }
        format.xml  { render :xml => @event, :status => :created, :location => @event }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.xml
  def update
    @event = Event.find(params[:id])
    authorize! :update, @event
    
    time_selector2ruby(@event)
    
    ret = @event.update_attributes(params[:event])
    
    respond_to do |format|
      if ret
        format.html { redirect_to(@event, :notice => I18n.t('tongshare.event.updated', :name => @event.name)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.xml
  def destroy
    @event = Event.find(params[:id])
    authorize! :destroy, @event
    @event.destroy

    respond_to do |format|
      format.html { redirect_to(events_url) }
      format.xml  { head :ok }
    end
  end



end

