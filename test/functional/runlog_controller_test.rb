require File.dirname(__FILE__) + '/../test_helper'
require 'runlog_controller'

# Re-raise errors caught by the controller.
class RunlogController; def rescue_action(e) raise e end; end

class RunlogControllerTest < Test::Unit::TestCase
  fixtures :runs, :users

  def setup
    @controller = RunlogController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'index'
  end

  def test_list
    get :list, {}, {:user => users(:tim)}

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:runs)
  end

  def test_show
    get :show, {:id => 1}, {:user => users(:tim)}

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:run)
    assert assigns(:run).valid?
  end

  def test_new
    get :new, {}, {:user => users(:tim)}

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:run)
  end

  def test_create
    
    num_runs = Run.count

    post :create, {:run => {:user_id => users(:tim).id, :when_run => "2006-06-12", :distance => 1255, :duration => 25, :description => "test_create run description" }}, {:user => users(:tim)}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_runs + 1, Run.count
    assert_equal 2, users(:tim).runs.count
    assert_equal 1255, users(:tim).runs[1].distance
    
  end

  def test_edit
    get :edit, {:id => 1}, {:user => users(:tim)}

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:run)
    assert assigns(:run).valid?
  end

  def test_update
#    post :update, {:id => 1}, {:run => {:distance => ""}}, {:user => users(:tim)}
    post :update, {:id => 1, :run => {:user_id => users(:tim).id, :when_run => "2006-06-12", :distance => 1255, :duration => 25, :description => "test_create run description" }}, {:user => users(:tim)}
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_update_with_empty_distance
    post :update, {:id => 1, :run => {:user_id => users(:tim).id, :when_run => "2006-06-12", :distance => "", :duration => 25, :description => "test_create run description" }}, {:user => users(:tim)}
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    assert_not_nil Run.find(1)

    post :destroy, {:id => 1}, {:user => users(:tim)}
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Run.find(1)
    }
  end
  
end
