class Food < ActiveRecord::Base
  belongs_to  :food_group
  has_many    :weights
  has_many    :food_nutrients

  acts_as_ferret  :fields => [ 'long_description' ]

  def energy
    nutrient('208')
  end

  def protein
    nutrient('203')
  end
  
  def carbohydrate
    nutrient('205')
  end
  
  def fat
    nutrient('204')
  end
  
  def nutrient(nutrient_number)
    food_nutrients.find(:all, :conditions => ['nutrient_number = :nutrient_number', {:nutrient_number => nutrient_number}])[0]
  end
  
  def self.full_text_search(q, options = {})
    return nil if q.nil? or q==""
    default_options = {:limit => 10, :page => 1}
    options = default_options.merge options
    options[:offset] = options[:limit] * (options.delete(:page).to_i-1)  
    results = Food.find_by_contents(q, options)
    return [results.total_hits, results]
  end

end
