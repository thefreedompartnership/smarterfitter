require File.dirname(__FILE__) + '/../test_helper'
require 'foods_controller'

# Re-raise errors caught by the controller.
class FoodsController; def rescue_action(e) raise e end; end

class FoodsControllerTest < Test::Unit::TestCase
  fixtures :foods

  def setup
    @controller = FoodsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = foods(:first).id
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:foods)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:food)
    assert assigns(:food).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:food)
  end

  def test_create
    num_foods = Food.count

    post :create, :food => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_foods + 1, Food.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:food)
    assert assigns(:food).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Food.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Food.find(@first_id)
    }
  end
end
