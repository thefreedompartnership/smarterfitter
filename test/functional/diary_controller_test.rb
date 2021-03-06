require File.dirname(__FILE__) + '/../test_helper'
require 'diary_controller'

# Re-raise errors caught by the controller.
class DiaryController; def rescue_action(e) raise e end; end

class DiaryControllerTest < Test::Unit::TestCase
  fixtures :users, :weights, :foods, :portions, :food_nutrients, :nutrients
  def setup
    @controller = DiaryController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_unauthorized_user_is_redirected_to_login_page
    get :index
    assert_redirected_to :controller => "welcome", :action => "login"
  end
  
  def test_authorized_user_is_successful
    log_in(users(:tim))
    assert_not_nil assigns("user")
    #so we want to check up on the three portions for today
    assert_equal 3, session[:user].portions_for(Date.today).length
    session[:user].portions_for(Date.today).each() do |portion|
      assert_tag :tag => "td", :content => portion.description
    end
    
    #also want to check that there are a certain number of calories for yesterday
    #might want to check that tim has eaten some things over 5 of the past 7 days
    #and 25 of the past 30 days and that those averages are coming out right
    #now, is that really something we want to test at this level or is that unit
    #testing for the User and PortionThing classes?
  end
  
  def test_default_date_is_set_to_today
      log_in(users(:tim))
      assert_equal Date.today, assigns("date")
  end
    
  def test_user_with_no_food_sees_message_to_add_food
    log_in(users(:monica))
    assert_not_nil assigns("user")
    assert_equal 0, session[:user].portions_for(Date.today).size
    assert_select "em", :text => "You haven't added any food today. Get started by searching for food on the right!"
  end
  
  def test_user_with_some_food_but_none_today_see_message
    log_in(users(:alice))
    assert_not_nil assigns("user")
    assert_equal 0, session[:user].portions_for(Date.today).size
    assert_tag :tag => "em", :content => "You haven't added any food today. Get started by searching for food on the right!"
  end

  def test_add_portion
    log_in(users(:tim))
    portions("one_hundred_grams_of_butter")
    number_of_user_portions = session[:user].user_portions.count
    post :add_portion, :portion => {:weight => portions("one_hundred_grams_of_butter").weight, 
                                    :quantity => BigDecimal.new("1")}, :date => Date.today.to_s
    assert_equal number_of_user_portions + 1, session[:user].user_portions.count
  end

  
  def test_show_portion
    log_in(users(:tim))
    get :show_portion, :id => portions("one_hundred_grams_of_butter").weight.food.id, :date => Date.today.to_s
    assert_not_nil assigns("portion")
    assert portions("one_hundred_grams_of_butter").weight.food.id, assigns("portion").weight.food.id
    assert portions("one_hundred_grams_of_butter").description, assigns("portion").description
  end
  
  
  def test_edit_portion
    log_in(users(:tim))
    get :edit_portion, :id => portions("one_hundred_grams_of_butter").weight.food.id, :date => Date.today.to_s
    assert_not_nil assigns("portion")
    assert portions("one_hundred_grams_of_butter").weight.food.id, assigns("portion").weight.food.id
    assert portions("one_hundred_grams_of_butter").description, assigns("portion").description
    assert_response :success
    assert_template "edit_portion"
  end
  
  def test_update_portion
    log_in(users(:tim))
    portion = users(:tim).user_portions[0]
    post :update_portion, :id => portion.id, :portion => {:weight => portion.weight, :quantity => "5" }, :date => Date.today.to_s
    assert_equal 5, users(:tim).user_portions[0].quantity
    assert_response :success
    assert_template "_today"
  end
  
  def test_delete_portion
    log_in(users(:tim))
    number_of_user_portions = session[:user].user_portions.count
    post :delete_portion, :id => session[:user].user_portions[0].id, :date => Date.today.to_s
    assert_equal number_of_user_portions - 1, session[:user].user_portions.count
    assert_response :success
    assert_template "_today"
  end

  private
  def log_in(user)
    get :index
    assert_redirected_to :controller => "welcome", :action => "login"
    session[:user] = user
    get :index
    assert_response :success
    assert_template "index"
  end
end
