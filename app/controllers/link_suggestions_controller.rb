class LinkSuggestionsController < ApplicationController
  
  layout 'standard'
  
  def index
    redirect_to :action => :new
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :index }


  def new
    @link_suggestion = LinkSuggestion.new
  end

  def create
    @link_suggestion = LinkSuggestion.new(params[:link_suggestion])
    if @link_suggestion.save
      flash[:notice] = 'Link suggestion was successfully created.'
      redirect_to :action => :thanks      
    else
      render :action => 'new'
    end
  end
  
  def feed
    @headers["Content-Type"] = "application/xml"
    @feed_title = "SmarterFitter link suggestions"
    @url = url_for(:controller => "link_suggestions", :action => "feed")
    @suggested_links = LinkSuggestion.find :all, :order => 'created_at DESC'
    render :layout => false
  end  
  
  
end
