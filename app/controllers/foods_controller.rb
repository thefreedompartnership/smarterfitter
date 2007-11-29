class FoodsController < ApplicationController
  
  layout "standard"
  
  def search 
    @query = params[:q]
    @total, @foods = Food.full_text_search(@query, {:limit => 15, :page => (params[:page]||1)}) 
    @food_pages = pages_for(@total, :per_page => 15)
  end
  
  def show
    @food = Food.find(params[:id])
    if params[:weight].nil?
      @weight = @food.weights[0]
    else
      @weight = Weight.find(params[:weight]['id'])      
    end
    if params[:amount].nil?
      @portion = PortionThing.new(@food, @weight, @weight.amount)
    else
      @amount = BigDecimal.new(params[:amount])
      @portion = PortionThing.new(@food, @weight, @amount)
    end
  end

end
