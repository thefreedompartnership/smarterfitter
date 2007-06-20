class FoodsController < ApplicationController
  
  layout "standard"
  
  before_filter :authorize, :except => [:index, :search, :show]
  
  
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


  def show_summary
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
    render(:layout => false)
  end
  
  def log
    @user = session[:user]
    @portions = @user.consumed_portions.find(:all, :conditions => ['created_at > ?', Date.today()], :order => "created_at DESC" )
    render(:layout => false)
  end
  
  def find_food
    @query = params[:q]
    @total, @foods = Food.full_text_search(@query, {:limit => 15, :page => (params[:page]||1)}) 
    @food_pages = pages_for(@total, :per_page => 15)
    render(:layout => false)
  end
  
  def add_food
    @food = Food.find(params['food_id'])
    @weight = nil
    @weight = Weight.find(params['weight_id']) if params['weight_id'] != ""
    weight_id = nil
    weight_id = @weight.id unless @weight.nil?
    @quantity = params['quantity'].to_f
    @consumed_portion = ConsumedPortion.new({:food_id => @food.id, :weight_id => weight_id, :quantity => @quantity})
    @user = session[:user]
    @user.consumed_portions << @consumed_portion
    @portions = @user.consumed_portions.find(:all, :conditions => ['created_at > ?', Date.today()], :order => "created_at DESC")
    render(:layout => false)
  end
  
  def remove_food
    @user = session[:user]
    @user.consumed_portions.find(params[:id]).destroy
    @portions = @user.consumed_portions.find(:all, :conditions => ['created_at > ?', Date.today()], :order => "created_at DESC")
    render(:layout => false)
  end
  
  def edit_food
    @user = session[:user]
    @consumed_portion = @user.consumed_portions.find(params[:id])
    
    @food = @consumed_portion.food
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
    render(:layout => false)
  end
  
  def update_food
    @food = Food.find(params['food_id'])
    @weight = nil
    @weight = Weight.find(params['weight_id']) if params['weight_id'] != ""
    weight_id = nil
    weight_id = @weight.id unless @weight.nil?
    @quantity = params['quantity'].to_f
    @user = session[:user]
    @consumed_portion = @user.consumed_portions.find(params['consumed_portion_id'])
    @consumed_portion.food = @food
    @consumed_portion.weight = @weight
    @consumed_portion.quantity = @quantity
    @consumed_portion.save
    @portions = @user.consumed_portions.find(:all, :conditions => ['created_at > ?', Date.today()], :order => "created_at DESC")
    render(:layout => false)
  end
end
