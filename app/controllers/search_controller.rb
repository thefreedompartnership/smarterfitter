class SearchController < ApplicationController
  def search
      @query = "%#{params[:q]}%"
      #@total = Food.find(:all, :conditions => ["long_description like ?", @query]).size
      @food_pages, @foods = paginate :foods, :per_page => 15, 
                                     :conditions => ["long_description like ?", @query], 
                                     :order => 'long_description'      
  end
end
