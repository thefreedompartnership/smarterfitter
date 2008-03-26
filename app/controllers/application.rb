# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  
  # this deals with STI in development not loading models properly until
  # it 'sees' them and then 
  require_dependency 'user_portion'
  require_dependency 'weight_portion'
  require_dependency 'recipe_portion'
  require_dependency 'ingredient_portion'
  
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery :secret => 'fa413b2119ff831fa5816f418e1893a4846fcd673157da50f647df2202e0aeb30cae7ffd24e83a3b2b7cd1d9cd43020b4565e8fbda66a0fb88bbe964ef777e5a'
  
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
