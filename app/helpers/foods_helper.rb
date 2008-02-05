require 'google_chart'
module FoodsHelper
  def show_chart
    GoogleChart::PieChart.new('320x200', nil ,false) do |pc|
      pc.data "Fat", @food.fat.nutrient_value
      pc.data "Protein", @food.protein.nutrient_value
      pc.data "Carbs", @food.carbohydrate.nutrient_value
      pc.data "Other", 100 - (@food.fat.nutrient_value + @food.protein.nutrient_value + @food.carbohydrate.nutrient_value)
      @chart_url = pc.to_url
    end
    content_tag :img, nil, :src => @chart_url
  end
end
