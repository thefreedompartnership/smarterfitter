class FoodsController < ApplicationController
  def index
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
