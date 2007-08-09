class DiaryController < ApplicationController
  
  before_filter :authorize
  
  def index
    if params[:year] && params[:month] && params[:day]
      @date = Date.parse("#{params[:year]}-#{params[:month]}-#{params[:day]}")
    else
      @date = Date.today
    end
    @user = session[:user]
  end
  
  def search
    @date = params[:date]
    @query = params[:q]
    @total, @foods = Food.full_text_search(@query, {:limit => 15, :page => (params[:page]||1)}) 
    @food_pages = pages_for(@total, :per_page => 15)
  end

  def add_portion
    @user = session[:user]
    @date = Date.parse(params[:date])
    portion = ConsumedPortion.new(params[:portion])
    @user.consumed_portions << portion
    render(:partial => "today")
  end
  
  
  def show_portion
    @user = session[:user]
    @date = Date.parse(params[:date])
    @food = Food.find(params[:id].to_i)
    if params[:portion]
      @portion = ConsumedPortion.new(params[:portion])
    else
      @portion = ConsumedPortion.new({:food_id => @food.id, :weight_id => @food.weights[0].id, :quantity => @food.weights[0].amount, :consumed_at => @date})
    end
  end
  
  def edit_portion
    @user = session[:user]
    @date = Date.parse(params[:date])
    @portion = @user.consumed_portions.find(params[:id])
    if params[:portion]
      @portion.weight = Weight.find(params[:portion][:weight_id])
      @portion.quantity = params[:portion][:quantity]
    end
  end
  
  def update_portion
    @user = session[:user]
    @date = Date.parse(params[:date])
    portion = @user.consumed_portions.find(params[:id])
    portion.update_attributes(params[:portion])
    render(:partial => "today")
  end
  
  def cancel_update_portion
    @user = session[:user]
    @date = Date.parse(params[:date])
    render(:partial => "today")
  end
  
  def delete_portion
    @user = session[:user]
    @date = Date.parse(params[:date])
    @user.consumed_portions.find(params[:id]).destroy
    render(:partial => "today")
  end
end
