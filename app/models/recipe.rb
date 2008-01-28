class Recipe < ActiveRecord::Base
  
  before_destroy :set_is_deleted_if_recipe_portions
  
  belongs_to :user
  has_many :ingredient_portions, :dependent => :destroy
  has_many :recipe_portions
  
  validates_presence_of :user
  validates_presence_of :servings
  validates_numericality_of :servings
  validates_presence_of :description
  validates_length_of :description, :maximum => 255
  validates_length_of :instructions, :maximum => 1000 * 6 # about a thousand words, not sure if there's any point to even limiting it
  
  def fat
    nutrient(Nutrient::FAT)
  end
  
  def protein
    nutrient(Nutrient::PROTEIN)
  end
  
  def energy
    nutrient(Nutrient::ENERGY)
  end
  
  def carbohydrate
    nutrient(Nutrient::CARBOHYDRATE)
  end
  
  def nutrient(nutrient_number)
    total = 0
    ingredient_portions.each { |portion| total += portion.nutrient(nutrient_number) }
    total
  end

  def nutrient_per_serving(nutrient_number)
    nutrient(nutrient_number) / self.servings
  end
  
  private
  
    def set_is_deleted_if_recipe_portions
      if recipe_portions.size > 0
        self.is_deleted = true
        save
        false
      end
    end
  
end
