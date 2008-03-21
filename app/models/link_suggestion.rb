class LinkSuggestion < ActiveRecord::Base
  
  validates_presence_of :title, :link, :description
    
end
