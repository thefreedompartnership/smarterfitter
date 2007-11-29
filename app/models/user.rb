require "digest/sha1"
class User < ActiveRecord::Base
  
  has_many :runs
  has_many :user_portions
  has_many :body_masses
  has_many :recipes, :conditions => "is_deleted != 1"
  
  attr_accessor :password, :confirm_password
  
  validates_uniqueness_of :user_name
  validates_presence_of :user_name, :email_address, :first_name, :last_name, :password
  
  composed_of :tz, :class_name => 'TZInfo::Timezone', :mapping => %w(time_zone identifier)

  def portions_for?(date)
    count = user_portions.count(:all, 
      :conditions => 
          ['portions.consumed_at >= ? and portions.consumed_at < ?', date, date + 1]
      ) != 0
  end

  def portions_for(date)
    user_portions.find(:all, 
      :conditions => ['portions.consumed_at >= ? and portions.consumed_at < ?', date, date + 1], 
      :order => "portions.created_at DESC")
  end
  
  def percent_calories_for(nutrient_number, nutrient_calorie_multiplier, date)
    total = nutrient_total_for(nutrient_number, date)
    if total != 0
      return ((total * nutrient_calorie_multiplier) / energy_for(date)) * 100      
    else
      return BigDecimal.new("0")      
    end
  end
  
  def percent_calories_from_protein_for(date)
    percent_calories_for(Nutrient::PROTEIN, 4, date)
  end
  def percent_calories_from_carbohydrate_for(date)
    percent_calories_for(Nutrient::CARBOHYDRATE, 4, date)
  end
  def percent_calories_from_fat_for(date)
    percent_calories_for(Nutrient::FAT, 9, date)
  end
  def percent_calories_from_saturated_fat_for(date)
    percent_calories_for(Nutrient::SATURATED_FAT, 9, date)
  end
  
  def nutrient_total_for(nutrient_number, start_date, end_date=start_date+1)
    query = <<-QUERY
      SELECT SUM(total) AS total FROM (
  
            SELECT SUM(fn.nutrient_value * ((p.quantity / w.amount)  
                * (w.weight_in_grams / 100))) AS total 
            FROM portions p, weights w, food_nutrients fn 
            WHERE w.id = p.weight_id 
              AND fn.food_id = w.food_id 
              AND fn.nutrient_number = #{nutrient_number}
              AND user_id = #{self.id}
              AND p.type = 'WeightPortion'
              AND p.consumed_at >= '#{start_date}'
              AND p.consumed_at <  '#{end_date}'
  
          UNION
  
            SELECT SUM((fn.nutrient_value * ((p.quantity / w.amount)
                * (w.weight_in_grams / 100)) 
                / r.servings) * recipes_consumed.servings_consumed) AS total 
            FROM portions AS p, weights AS w, food_nutrients AS fn, recipes AS r,
            (SELECT p.id AS recipe_portion_id, p.quantity AS servings_consumed, p.recipe_id recipe_consumed
                FROM portions p
                WHERE p.type = 'RecipePortion'
                AND p.user_id = #{self.id}
                AND p.consumed_at >= '#{start_date}'
                AND p.consumed_at <  '#{end_date}') AS recipes_consumed
  
            WHERE p.type = 'IngredientPortion'
            AND w.id = p.weight_id
            AND fn.food_id = w.food_id 
            AND fn.nutrient_number = #{nutrient_number} 
            AND p.recipe_id = r.id
            AND r.id = recipes_consumed.recipe_consumed
      ) AS totals
    QUERY
    total = User.connection.select_value(query)
    if total.nil?
      return BigDecimal.new("0")
    else
      return BigDecimal.new(total)
    end
  end
  
  def energy_for(date)
    nutrient_total_for(Nutrient::ENERGY, date)
  end
  def fat_for(date)
    nutrient_total_for(Nutrient::FAT, date)
  end
  def saturated_fat_for(date)
    nutrient_total_for(Nutrient::SATURATED_FAT, date)
  end
  def protein_for(date)
    nutrient_total_for(Nutrient::PROTEIN, date)
  end
  def carbohydrate_for(date)
    nutrient_total_for(Nutrient::CARBOHYDRATE, date)
  end

  
  def average_energy_last_seven_days
    average_nutrient(Nutrient::ENERGY, Date.today - 8, Date.today)
  end

  def average_protein_last_seven_days
    average_nutrient(Nutrient::PROTEIN, Date.today - 8, Date.today)
  end

  def average_carbohydrate_last_seven_days
    average_nutrient(Nutrient::CARBOHYDRATE, Date.today - 8, Date.today)
  end

  def average_fat_last_seven_days
    average_nutrient(Nutrient::FAT, Date.today - 8, Date.today)
  end

  def average_energy_last_thirty_days
    average_nutrient(Nutrient::ENERGY, Date.today - 31, Date.today)
  end

  def average_protein_last_thirty_days
    average_nutrient(Nutrient::PROTEIN, Date.today - 31, Date.today)
  end

  def average_fat_last_thirty_days
    average_nutrient(Nutrient::FAT, Date.today - 31, Date.today)
  end

  def average_carbohydrate_last_thirty_days
    average_nutrient(Nutrient::CARBOHYDRATE, Date.today - 31, Date.today)
  end


  def average_energy
    average_nutrient(Nutrient::ENERGY, Date.parse("1970-01-01"), Date.today)
  end

  def average_protein
    average_nutrient(Nutrient::PROTEIN, Date.parse("1970-01-01"), Date.today)
  end

  def average_fat
    average_nutrient(Nutrient::FAT, Date.parse("1970-01-01"), Date.today)
  end

  def average_carbohydrate
    average_nutrient(Nutrient::CARBOHYDRATE, Date.parse("1970-01-01"), Date.today)
  end


  def average_nutrient(nutrient_number, start_date, end_date)
    
    total_nutrient = nutrient_total_for(nutrient_number, start_date, end_date)
    number_of_days_recorded = user_portions.count("distinct(date(consumed_at))", 
      :conditions => ['portions.consumed_at >= ? and portions.consumed_at < ?', start_date, end_date])
    if number_of_days_recorded > 0
      return (total_nutrient / number_of_days_recorded).round
    else
      return BigDecimal.new("0")
    end
  end

  def validate_on_create
    if password != confirm_password
      errors.add(:confirm_password, "is does not match your password")
    end
  end
  
  #authentication methods
  def self.login(user_name, password)
    hashed_password = hash_password(password || "")
    find(:first,
         :conditions => ["user_name = ? and hashed_password = ?", user_name, hashed_password])
  end
  
  def try_to_login
    User.login(self.user_name, self.password)
  end
  
  
  #lifecycle callback methods
  
  def before_create
    self.hashed_password = User.hash_password(self.password)
  end
  
  def after_create
    @password = nil
  end
  
  private
  def self.hash_password(password)
    Digest::SHA1.hexdigest(password)
  end
    
end
