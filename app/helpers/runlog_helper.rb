module RunlogHelper
  
  def meters_per_distance_unit
    if @run.distance_unit == "miles"
      Run::METERS_PER_MILE
    else
      Run::METERS_PER_KILOMETER
    end
  end
  
  def distance_and_unit(run)
    if run.distance then
      result = run.distance.to_s
      if run.distance_unit == 'kilometers'
        result += ' km'
      elsif run.distance_unit == 'miles'
        result += 'mi'
      end
      return result
    end
  end
  
  def format_datetime(datetime)
    return datetime if !datetime.respond_to?(:strftime)
    datetime = @user.tz.utc_to_local(datetime) if @user
    datetime.strftime("%m-%d-%Y %I:%M %p")
  end
end
