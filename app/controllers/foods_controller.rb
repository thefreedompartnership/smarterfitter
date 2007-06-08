class FoodsController < ApplicationController
  
  def search
      @query = "%#{params[:q]}%"
      #@total = Food.find(:all, :conditions => ["long_description like ?", @query]).size
      @food_pages, @foods = paginate :foods, :per_page => 15, 
                                     :conditions => ["long_description like ?", @query], 
                                     :order => 'long_description'      
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
