class FoodsController < ApplicationController
  
  def search 
    @query = params[:q]
    @total, @foods = Food.full_text_search(@query, {:limit => 15, :page => (params[:page]||1)}) 
    @food_pages = pages_for(@total, :per_page => 15)
  end
  
  def show
    @food = Food.find(params[:id])
    @weight = Weight.one_hundred_grams
    if params[:measure] != "0" and params[:measure] != nil
      @weight = Weight.find(params[:measure])      
    end
    if params[:amount] != nil
      @amount = params[:amount].to_f
      @portion = Portion.new(@food, @weight, @amount)
    else
      @portion = Portion.new(@food, @weight, 1)
    end
  end
  
end
