module DiaryHelper
  def friendly_date
      @date.to_s(:diary)
  end
  
  def users_prefered_distance_unit
    if @user.measurement_system == "metric"
      "kg"
    else
      "lbs"
    end
  end
end
