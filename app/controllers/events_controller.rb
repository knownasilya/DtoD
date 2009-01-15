class EventsController < ApplicationController  
  include GeoKit::Geocoders
  
  before_filter :login_required, :except => [:index, :show, :map]
  before_filter :user_has_permissions, :except => [:index, :show]

  
  # GET /events
  # GET /events.xml
  def index    
    @events = Event.find(:all)  
   
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
    end
  end
  
  # GET /events/1
  # GET /events/1.xml
  def show
    @event = Event.find(params[:id])
    map

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/new
  # GET /events/new.xml
  def new
    @event = Event.new 

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/1/edit
  def edit 
    authorized?
    @event = Event.find(params[:id])    
  end

  # POST /events
  # POST /events.xml
  def create
    @event = Event.new(params[:event])
    @event.user_id = current_user.id

    respond_to do |format|
      if @event.save
        flash[:notice] = 'Event was successfully created.'
        format.html { redirect_to(@event) }
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

    respond_to do |format|
      if @event.update_attributes(params[:event])
        flash[:notice] = 'Event was successfully updated.'
        format.html { redirect_to(@event) }
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
    @event.destroy

    respond_to do |format|
      format.html { redirect_to(events_url) }
      format.xml  { head :ok }
    end
  end
  
  def map
    @event = Event.find(params[:id]) 
    
    #YM4R_GM Initialization
    lat = MultiGeocoder.geocode(@event.location).lat
    lng = MultiGeocoder.geocode(@event.location).lng    
    @marker = GMarker.new([lat, lng], :title => @event.name, :info_window => @event.description)  
    @map = GMap.new("map_div_id")  
    @map.control_init(:large_map => true, :map_type => true)  
    @map.center_zoom_init([lat, lng], 10)  
    @map.overlay_init(@marker)
  end
  
private
  
  def user_has_permissions
    begin
      @event = Event.find(params[:id]) # throws exception -> rescue if id is nil/blank
      current_user == @event.user || is_admin? || access_denied # returns true or false
    rescue
      is_admin? || logged_in? || access_denied # returns true or false
    end
  end

  
  def is_admin?
    if logged_in? 
      current_user.admin == true
    else
      false
    end
  end
end


