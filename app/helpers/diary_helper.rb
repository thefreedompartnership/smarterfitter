module DiaryHelper
  def friendly_date
      @date.to_s(:diary)
  end
end
