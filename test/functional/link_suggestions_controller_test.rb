require File.dirname(__FILE__) + '/../test_helper'
require 'link_suggestions_controller'

# Re-raise errors caught by the controller.
class LinkSuggestionsController; def rescue_action(e) raise e end; end

class LinkSuggestionsControllerTest < Test::Unit::TestCase
  fixtures :link_suggestions

  def test_x
  end
end
