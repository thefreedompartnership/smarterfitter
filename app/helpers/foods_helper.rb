require 'google_chart'
module FoodsHelper

  WATER_COLOR = "ffc266"
  PROTEIN_COLOR = "ffd799"
  CARB_COLOR = "ffebcc"
  FAT_COLOR = "ff9900"
  
  def show_chart
    GoogleChart::PieChart.new('280x150', "Proportion of weight by nutrient" ,false) do |pc|
      chart_data = @portion.to_chart_data
      pc.data "Fat", chart_data['Fat'], FAT_COLOR
      pc.data "Carbs", chart_data['Carbs'], CARB_COLOR
      pc.data "Protein", chart_data['Protein'], PROTEIN_COLOR
      pc.data "Water", chart_data['Water'], WATER_COLOR
      @chart_url = pc.to_url
    end
    content_tag :img, nil, :src => @chart_url
  end
  
  def show_percent_energy_chart
    GoogleChart::PieChart.new('280x150', "Proportion of calories by nutrient", false) do |pc|
      pc.data "Fat #{number_to_percentage(@food.percent_energy_from_fat, :precision => 1)}", @food.percent_energy_from_fat, FAT_COLOR
      pc.data "Carbs #{number_to_percentage(@food.percent_energy_from_carbohydrate, :precision => 1)}", @food.percent_energy_from_carbohydrate, CARB_COLOR
      pc.data "Protein #{number_to_percentage(@food.percent_energy_from_protein, :precision => 1)}", @food.percent_energy_from_protein, PROTEIN_COLOR
      @chart_url = pc.to_url
    end
    content_tag :img, nil, :src => @chart_url
  end
end
