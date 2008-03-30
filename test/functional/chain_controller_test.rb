require File.dirname(__FILE__) + '/../test_helper'
require 'chain_controller'

# Re-raise errors caught by the controller.
class ChainController; def rescue_action(e) raise e end; end

class ChainControllerTest < Test::Unit::TestCase
  def setup
    @controller = ChainController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test_chain_handles_update_without_session
    get :update_chain, :id => "2007-12-20"
    assert_redirected_to :action => :index
  end
end
