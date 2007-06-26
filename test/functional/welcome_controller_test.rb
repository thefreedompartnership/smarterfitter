require File.dirname(__FILE__) + '/../test_helper'
require 'welcome_controller'

# Re-raise errors caught by the controller.
class WelcomeController; def rescue_action(e) raise e end; end

class WelcomeControllerTest < Test::Unit::TestCase
  fixtures :users
  def setup
    @controller = WelcomeController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_login_with_valid_user
    tim = users(:tim)
    post :login, :user => {:user_name => tim.user_name, :password => "password"}
    assert_redirected_to :controller => "welcome", :action => "thankyou"
    assert_not_nil(session[:user])
    assert_equal(tim.user_name, session[:user].user_name)
  end
end
