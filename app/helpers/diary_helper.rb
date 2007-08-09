module DiaryHelper
  def friendly_date
    if @date == Date.today
      "Today"
    else
      @date.to_s(:diary)
    end
  end
end
