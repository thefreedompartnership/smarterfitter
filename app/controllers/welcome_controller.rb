class WelcomeController < ApplicationController
  layout "standard"
  
  def index
    redirect_to '/blog/'
  end
  
  def signup
    if request.get?
      session[:source] = params[:source]
      @user = User.new
    else
      @user = User.new(params[:user])
      if @user.save
        flash[:notice] = 'Thank you for signing up'
        session[:user] = @user
        source = session[:source]
        session[:source] = nil
        if("foods" == source)
          redirect_to :controller => 'diary', :action => 'index'
        elsif("runlog" == source)
          redirect_to :controller => 'runlog', :action => 'list'
        else
          redirect_to :action => 'thankyou'
        end
      end
    end
  end
  
  def login
    if request.get?
      session[:user_id] = nil
      @user = User.new
    else
      @user = User.new(params[:user])
      logged_in_user = @user.try_to_login
      if logged_in_user
        session[:user] = logged_in_user
        if(!nil_or_empty(params[:goto_controller]) && !nil_or_empty(params[:goto_action]))
          logger.info("found params[:gc] = '#{params[:goto_controller]}' and params[:ga] = '#{params[:goto_action]}'")
          jumpto = {:controller => params[:goto_controller], :action => params[:goto_action]}
        else
          jumpto = session[:jumpto] || { :action => 'thankyou' }
          logger.info("setting jumpto = '#{jumpto}'")
        end
        
        session[:jumpto] = nil
        redirect_to jumpto
      else
        flash[:notice] = "Invalid login user name / password"
        @goto_controller = params[:goto_controller]
        @goto_action = params[:goto_action]
      end
    end
  end
  
  
  
  def logout
    session[:user] = nil
    flash[:notice] = "Thank you and come again"
    redirect_to :action => 'index'
  end
  
  private
  
  def nil_or_empty(s)
    return s.nil? || "" == s
  end
    
  
end
