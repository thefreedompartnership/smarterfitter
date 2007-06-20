# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_smarterfitter_session_id'
  
  def pages_for(size, options = {})
    default_options = {:per_page => 10}
    options = default_options.merge options
    pages = Paginator.new self, size, options[:per_page], (params[:page]||1)
    pages
  end
  
  def authorize
    unless session[:user]
      flash[:notice] = "Please log in"
      session[:jumpto] = request.parameters
      redirect_to(:controller => "welcome", :action => "login")
    end
  end
  
end
