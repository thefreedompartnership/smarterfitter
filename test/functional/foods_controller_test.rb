require File.dirname(__FILE__) + '/../test_helper'
require 'foods_controller'

# Re-raise errors caught by the controller.
class FoodsController; def rescue_action(e) raise e end; end

class FoodsControllerTest < Test::Unit::TestCase
  def test_truth
    assert true
  end
end
