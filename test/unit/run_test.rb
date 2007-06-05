require File.dirname(__FILE__) + '/../test_helper'

class RunTest < Test::Unit::TestCase

  fixtures :runs, :users

  def test_duration_is_not_required
    runs(:first).duration = nil
    assert_valid runs(:first)
    runs(:first).save
  end
  
  def test_duration_is_not_required
    runs(:first).distance = nil
    assert_valid runs(:first)
    runs(:first).save
  end 
  
  def test_distance_can_be_read_in_km    
    assert_equal 1.5, runs(:first).distance
  end
  
  def test_change_distance_in_km
    runs(:first).distance = 2.5
    runs(:first).save
    @run = Run.find(1)
    assert_equal 2.5, @run.distance
    runs(:first).distance = 2.509
    runs(:first).save
    @run = Run.find(1)
    assert_equal 2.509, @run.distance
  end
  
  def test_distance_can_be_read_in_miles
    @mile_user = users(:mile_user)
    assert_equal 'imperial', @mile_user.measurement_system
    assert_equal 1, @mile_user.runs[0].distance
  end

  def test_change_distance_in_miles
    @mile_user = users(:mile_user)
    @mile_user.runs[0].distance = 3.5
    @mile_user.runs[0].save
    @run = @mile_user.runs[0].reload
    @run = @mile_user.runs[0]
    assert_equal 3.5, @run.distance
  end

  def test_duration_in_seconds_from_string
    assert_nil Run.duration_in_seconds_from_string(nil)
    assert_nil Run.duration_in_seconds_from_string("")
    assert_equal 0, Run.duration_in_seconds_from_string("0")
    assert_equal 60, Run.duration_in_seconds_from_string("1")
    assert_equal 60, Run.duration_in_seconds_from_string("1m")
    assert_equal 1, Run.duration_in_seconds_from_string("1s")
    assert_equal 11, Run.duration_in_seconds_from_string("11s")
    assert_equal 601, Run.duration_in_seconds_from_string("10m 1s")
    assert_equal 3661, Run.duration_in_seconds_from_string("1h 1m 1s")
    assert_equal 3661, Run.duration_in_seconds_from_string("1 h 1 m 1 s")
    assert_equal 3661, Run.duration_in_seconds_from_string("1 hr 1min 1s")
    assert_equal 60 * 60 + 11 * 60 + 1, Run.duration_in_seconds_from_string("1 hour 11 minutes 1 second")
    assert_equal 3660, Run.duration_in_seconds_from_string("1h 1m")
    assert_equal 3600, Run.duration_in_seconds_from_string("1h")
    assert_equal 3600, Run.duration_in_seconds_from_string("1 hour")
    assert_equal 3600, Run.duration_in_seconds_from_string("1 hr")
    assert_equal 4 * 3600, Run.duration_in_seconds_from_string("4 hrs")    
  end

  def test_duration_in_seconds_as_string
    assert_equal "", Run.duration_in_seconds_as_string(nil)
    assert_equal "1 hr 20 min 3 sec", Run.duration_in_seconds_as_string(1 * 60 * 60 + 20 * 60 + 3)
    assert_equal "20 min 3 sec", Run.duration_in_seconds_as_string(20 * 60 + 3)
    assert_equal "20 min", Run.duration_in_seconds_as_string(20 * 60)
    assert_equal "3 sec", Run.duration_in_seconds_as_string(3)
    assert_equal "1 hr 0 min 3 sec", Run.duration_in_seconds_as_string(1 * 60 * 60 + 0 * 60 + 3)
  end
end
