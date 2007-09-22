require File.dirname(__FILE__) + '/../test_helper'

class BodyMassTest < Test::Unit::TestCase
  fixtures :users, :body_masses

  def test_to_lbs
    m = BodyMass.new(:mass => "1.0")
    assert_equal(BigDecimal.new("2.20462262"), m.to_lbs)
    m = BodyMass.new(:mass => "2.0")
    assert_equal(BigDecimal.new("2.20462262") * 2, m.to_lbs)
  end
end
