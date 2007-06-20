class RunlogController < ApplicationController
  
  before_filter :authorize, :except => [:index, :show]
  
  
  def index
    if session[:user] then
      redirect_to(:controller => "runlog", :action => "list")
    end
  end

  def pick_location
    if request.get?
      @user = session[:user]
    else
      @user = session[:user]
      if @user.update_attribute('default_latitude', params[:user][:default_latitude]) &&
         @user.update_attribute('default_longitude', params[:user][:default_longitude]) &&
         @user.update_attribute('default_zoom', params[:user][:default_zoom])         
        flash[:notice] = 'Default location saved.'
        redirect_to :action => 'list'
      else
        render :action => 'pick_location'
      end
    end
  end

  def pick_location_ajax
      @user = session[:user]
      if @user.update_attribute('default_latitude', params[:user][:default_latitude]) &&
         @user.update_attribute('default_longitude', params[:user][:default_longitude]) &&
         @user.update_attribute('default_zoom', params[:user][:default_zoom])         
        render :text => 'Default location saved'
      else
        render :text => 'Default location could not be saved'
      end
  end


  def list
    @user = session[:user]
    @run_pages = Paginator.new self, session[:user].runs.count, 10, params[:page]
    @runs = session[:user].runs.find :all, :order => "when_run DESC",
            :limit => @run_pages.items_per_page, :offset => @run_pages.current.offset
    @run = Run.new
    @run.distance_unit = users_default_distance_unit()
    @run.when_run = session[:user].tz.utc_to_local(Time.now)
  end

  def show
    @run = Run.find(params[:id])
    @user = User.find(@run.user_id)
  end

  def new
    @run = Run.new
    @run.distance_unit = users_default_distance_unit()
    @run.when_run = session[:user].tz.utc_to_local(Time.now)
  end

  def create
    @run = Run.new(params[:run])
    @run.when_run = session[:user].tz.local_to_utc(@run.when_run)
    if session[:user].runs << @run
      flash[:notice] = 'Run was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end
  
  def create_ajax
    #can't we just replace the entire div each time rather than the error messages?
    @run = Run.new(params[:run])
    @run.when_run = session[:user].tz.local_to_utc(@run.when_run)
    if session[:user].runs << @run
      render(:partial => "run", :object => @run, :layout => false)
    else
      render(:partial => "errors", :object => @run, :layout => false, :status => 500)
    end
  end
  
  def edit
    @user = session[:user]
    @run = Run.find(params[:id])
    if @run.user_id != session[:user].id
      flash[:notice] = 'That''s not your run!'
      redirect_to :action => 'list'
    end
  end

  def update
    @run = Run.find(params[:id])
    if @run.user_id == session[:user].id
      @run.attributes = params[:run]
      @run.when_run = session[:user].tz.local_to_utc(@run.when_run)
      if @run.save
        flash[:notice] = 'Run was successfully updated.'
        redirect_to :action => 'show', :id => @run
      else
        render :action => 'edit'
      end
    else
      flash[:notice] = 'That''s not your run!'
      redirect_to :action => 'list'
    end
  end

  def destroy
    @run_to_destroy = Run.find(params[:id])
    if @run_to_destroy.user_id == session[:user].id
      @run_to_destroy.destroy
    else
      flash[:notice] = 'That''s not your run!'
    end
    redirect_to :action => 'list'
  end

  def users_default_distance_unit
    if session[:user].measurement_system == "imperial"
      "miles"
    else
      "kilometers"
    end
  end

end
