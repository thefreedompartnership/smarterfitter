class RunsController < ApplicationController
  def index    
    if @user = User.find_by_user_name(params[:user_name])
      @run_pages = Paginator.new self, @user.runs.count, 10, params[:page]
      @runs = @user.runs.find :all, :order => "when_run DESC",
              :limit => @run_pages.items_per_page, :offset => @run_pages.current.offset
      render :action => 'runs_for_user'
    else    
      @run_pages = Paginator.new self, Run.count, 20, params[:page]
      @runs = Run.find :all, :order => 'when_run DESC',
                       :limit  =>  @run_pages.items_per_page,
                       :offset =>  @run_pages.current.offset
    end
  end
  
  
  def feed
    # response.headers["Content-Type"] => "application/xml"
    @feed_title = "Run Log: Everyone's Runs"
    @url = url_for(:controller => "runs", :action => "feed")
    if @user = User.find_by_user_name(params[:user_name])
      @runs = @user.runs.find :all, :order => "when_run DESC"
      @feed_title = "Run Log: " + @user.user_name + "'s Runs"
    else    
      @runs = Run.find :all, :order => 'when_run DESC'
    end
    render :layout => false
  end  
end
