require File.dirname(__FILE__) + '/../test_helper'
require 'calculators_controller'

# Re-raise errors caught by the controller.
class CalculatorsController; def rescue_action(e) raise e end; end

class CalculatorsControllerTest < Test::Unit::TestCase
  def setup
    @controller = CalculatorsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
