class DiaryController < ApplicationController
  
  before_filter :authorize
  
  def index
    @user = session[:user]
    if params[:year] && params[:month] && params[:day]
      @date = Date.parse("#{params[:year]}-#{params[:month]}-#{params[:day]}")
    else
      @date = Date.today
    end

    if flash[:body_mass_error]
      @body_mass = BodyMass.new(:mass => flash[:body_mass_entry], :recorded_at => @date)
    else
      @body_mass = find_body_mass_or_get_empty_body_mass(@user, @date)
    end
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
    portion = WeightPortion.new(params[:portion])
    @user.user_portions << portion
    render(:partial => "today")
  end
  
  def add_recipe_portion
    @user = session[:user]
    @date = Date.parse(params[:date])
    recipe_portion = RecipePortion.new(params[:recipe_portion])
    @user.user_portions << recipe_portion
    render(:partial => "today")
  end  
  
  def show_portion
    @user = session[:user]
    @date = Date.parse(params[:date])
    @food = Food.find(params[:id].to_i)
    if params[:portion]
      @portion = WeightPortion.new(params[:portion])
    else
      @portion = WeightPortion.new({:weight_id => @food.weights[0].id, :quantity => @food.weights[0].amount, :consumed_at => @date})
    end
  end

  def show_recipe
    @user = session[:user]
    @date = Date.parse(params[:date])
    @recipe = @user.recipes.find(params[:id])
    if params[:recipe_portion]
      @recipe_portion = RecipePortion.new(params[:recipe_portion])
    else
      @recipe_portion = RecipePortion.new(:recipe => @recipe, :quantity => 1, :consumed_at => @date)
    end
  end
  
  def edit_portion
    @user = session[:user]
    @date = Date.parse(params[:date])
    @portion = @user.user_portions.find(params[:id])
    if params[:portion]
      @portion.weight = Weight.find(params[:portion][:weight_id])
      @portion.quantity = params[:portion][:quantity]
    end
  end
  
  def edit_recipe_portion
    @user = session[:user]
    @date = Date.parse(params[:date])
    @portion = @user.user_portions.find(params[:id])
    if params[:portion]
      @portion.quantity = params[:portion][:quantity]
    end
  end

  def update_portion
    @user = session[:user]
    @date = Date.parse(params[:date])
    portion = @user.user_portions.find(params[:id])
    portion.update_attributes(params[:portion])
    render(:partial => "today")
  end

  def update_recipe_portion
    @user = session[:user]
    @date = Date.parse(params[:date])
    portion = @user.user_portions.find(params[:id])
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
    @user.user_portions.find(params[:id]).destroy
    render(:partial => "today")
  end
  
  def update_body_mass
    user = session[:user]
    if params[:id]
      body_mass = user.body_masses.find(params[:id])
      is_saved = body_mass.update_attributes(params[:body_mass])        
    else
      is_saved = user.body_masses << BodyMass.new(params[:body_mass])
    end
    unless is_saved
      flash[:body_mass_error] = "Invalid weight, please enter a number"
      flash[:body_mass_entry] = params[:body_mass][:mass]
    end
    redirect_to :back
  end
  
  private
  def find_body_mass_or_get_empty_body_mass(user, date)
    if user.body_masses.find_by_recorded_at(date)
      body_mass = user.body_masses.find_by_recorded_at(date)
    else
      body_mass = BodyMass.new(:recorded_at => date)
    end
    body_mass
  end
  
  
end


