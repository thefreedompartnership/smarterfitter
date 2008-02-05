require 'google_chart'
module FoodsHelper
  def show_chart
    GoogleChart::PieChart.new('320x200', nil ,false) do |pc|
      chart_data = @portion.to_chart_data
      chart_data.keys.each do |key|
        pc.data key, chart_data[key]
      end
      @chart_url = pc.to_url
    end
    content_tag :img, nil, :src => @chart_url
  end
end
