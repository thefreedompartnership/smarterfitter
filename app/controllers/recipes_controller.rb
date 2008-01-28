class RecipesController < ApplicationController
  layout "standard"
  before_filter :authorize  
  
  def index
    @user = session[:user]
    @recipes = @user.recipes
  end
  
  def show
    @user = session[:user]
    @recipe = @user.recipes.find(params[:id])
  end
  
  def edit
    @user = session[:user]
    @recipe = @user.recipes.find(params[:id])
  end

  def update
    @user = session[:user]
    @recipe = @user.recipes.find(params[:id])
    @recipe.update_attributes(params[:recipe])
    @recipe.save!
    flash[:notice] = "Your changes have been saved!"
    redirect_to :action => :index    
  end
  
  def new
    @user = session[:user]
    @recipe = Recipe.new
  end
  
  def create
    @user = session[:user]
    @recipe = Recipe.new(params[:recipe])
    @ingredients = []
    params[:portion].keys.each do |key|
      @ingredients << IngredientPortion.new(:quantity => params[:portion][key]['quantity'], :weight => Weight.find(params[:portion][key]['weight_id']))
    end
    Recipe.transaction do
      @ingredients.each { |i| @recipe.ingredient_portions << i }
      @recipe.ingredient_portions.each {|i| puts i.to_yaml}
      @recipe.save!
      redirect_to :action => :index
    end
  rescue ActiveRecord::RecordInvalid => e 
    @recipe.valid? # force checking of errors even if products failed 
    @ingredients.each { |i| i.valid? }
    render :action => :new
  end
  
  def search
    @query = params[:q]
    @total, @foods = Food.full_text_search(@query, {:limit => 15, :page => (params[:page]||1)}) 
    @food_pages = pages_for(@total, :per_page => 15)
    render :layout => false
  end
  
  def show_portion
    @user = session[:user]
    @food = Food.find(params[:id].to_i)
    if params[:portion]
      @portion = IngredientPortion.new(:quantity => params[:portion][:quantity], :weight => Weight.find(params[:portion][:weight_id]))
    else
      @portion = IngredientPortion.new(:quantity => @food.weights[0].amount, :weight => @food.weights[0])
    end
    render :layout => false
  end
  
  def add_portion
    @user = session[:user]
    @portion = IngredientPortion.new(:quantity => params[:portion][:quantity], :weight => Weight.find(params[:portion][:weight_id]))
    render :update do |page|
      page.insert_html :bottom, 'ingredients_list', 
        :partial => "ingredient", :locals => { :i => Time.now.to_i, :ingredient => @portion }
    end
  end
  
  def delete_portion
    render :update do |page|
      page.remove("portion_#{params[:id]}")
    end
  end
  
  def delete_saved_portion
    @user = session[:user]
    @ingredient_portion = IngredientPortion.find(params[:id])
    if @ingredient_portion.recipe.user == @user
      @ingredient_portion.destroy
      render :udpate do |page|
        page.remove("portion_#{params[:id]}")
      end
    end
  end
  
  def delete
    @user = session[:user]
    @user.recipes.find(params[:id]).destroy
    # this is an interesting case because we either want to destroy it
    # and cascade if the recipe isn't used in any recipe portions
    # or just mark it as "deleted" otherwise and then ignore it in
    # the future using something like one of those conditions in the
    # has many. but we don't want to do this coding here, we just want to
    # overload the destroy instance, i think
    flash[:notice] = "Recipe deleted"
    redirect_to :action => :index
  end
  
end
