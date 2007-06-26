class Food < ActiveRecord::Base
  belongs_to  :food_group
  has_many    :weights, :order => "sequence"
  has_many    :food_nutrients

  acts_as_ferret({ :fields => { :first_word_of_short_description => { :boost => 1000 }, :long_description => { :boost => 0 } } ,
                    :index_dir => "#{FERRET_INDEX_DIR_PREFIX}/index/#{RAILS_ENV}/food" })
  
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
  
  def weights_as_measure_id_array
    r = []
    weights.each { |w| r.push([w.measure_description, w.id]) }
    return r
  end

  def first_word_of_short_description
    attributes["short_description"].split()[0]
  end
  
  def self.full_text_search(q, options = {})
    return [ 0, [] ] if q.nil? or q==""

    terms = q.split()
    query = ""
    terms.each do |term|
      query += "#{term}* "
    end
    
    default_options = {:limit => 10, :page => 1}
    options = default_options.merge options
    options[:offset] = options[:limit] * (options.delete(:page).to_i-1)
    results = Food.find_by_contents(query, options)
    
    return [results.total_hits, results]
  end
  
  def wibble
    self.long_description
  end

end
