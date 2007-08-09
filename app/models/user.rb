require "digest/sha1"
class User < ActiveRecord::Base
  
  has_many :runs
  has_many :consumed_portions
  
  attr_accessor :password, :confirm_password
  
  validates_uniqueness_of :user_name
  validates_presence_of :user_name, :email_address, :first_name, :last_name, :password
  
  composed_of :tz, :class_name => 'TZInfo::Timezone', :mapping => %w(time_zone identifier)

  def portions_for?(date)
    consumed_portions.count(:all, 
      :conditions => 
          ['consumed_portions.consumed_at >= ? and consumed_portions.consumed_at < ?', date, date + 1]
      ) != 0
  end

  def portions_for(date)
    consumed_portions.find(:all, 
      :conditions => ['consumed_portions.consumed_at >= ? and consumed_portions.consumed_at < ?', date, date + 1], 
      :order => "consumed_portions.created_at DESC", :include => [:weight, :food])
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
  
  def nutrient_total_for(nutrient_number, date)
    total = 0
    consumed_portions.find(:all, 
      :conditions => ['consumed_portions.consumed_at >= ? and consumed_portions.consumed_at < ?', date, date + 1], 
      :include => [:weight, :food]
      ).each do |portion|
        total += portion.portion.nutrient(nutrient_number)
    end
    return total
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
    average_nutrient(Nutrient::ENERGY, @@for_past_7_days)
  end

  def average_protein_last_seven_days
    average_nutrient(Nutrient::PROTEIN, @@for_past_7_days)
  end

  def average_carbohydrate_last_seven_days
    average_nutrient(Nutrient::CARBOHYDRATE, @@for_past_7_days)
  end

  def average_fat_last_seven_days
    average_nutrient(Nutrient::FAT, @@for_past_7_days)
  end

  def average_energy_last_thirty_days
    average_nutrient(Nutrient::ENERGY, @@for_past_30_days)
  end

  def average_protein_last_thirty_days
    average_nutrient(Nutrient::PROTEIN, @@for_past_30_days)
  end

  def average_fat_last_thirty_days
    average_nutrient(Nutrient::FAT, @@for_past_30_days)
  end

  def average_carbohydrate_last_thirty_days
    average_nutrient(Nutrient::CARBOHYDRATE, @@for_past_30_days)
  end

  def average_energy
    average_nutrient(Nutrient::ENERGY)
  end

  def average_protein
    average_nutrient(Nutrient::PROTEIN)
  end
  
  def average_carbohydrate
    average_nutrient(Nutrient::CARBOHYDRATE)
  end
  
  def average_fat
    average_nutrient(Nutrient::FAT)
  end
  

  def average_nutrient(nutrient_number, period=@@for_past)
    portions = consumed_portions.find(:all, :conditions => period, :include => [:weight, :food])
    if portions.size > 0
      total_nutrient = BigDecimal.new("0")
      portions.each {|portion| total_nutrient += portion.nutrient(nutrient_number)}
      number_of_days_recorded = consumed_portions.count("distinct(date(consumed_at))", :conditions => period)
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
  
  @@for_today = ['consumed_portions.consumed_at > ?', Date.today()]
  @@for_yesterday = ['consumed_portions.consumed_at >= ? and consumed_portions.consumed_at < ?', Date.today() - 1, Date.today()]
  @@for_past_7_days = ['consumed_portions.consumed_at >= ? and consumed_portions.consumed_at < ?', Date.today() - 7, Date.today()]
  @@for_past_30_days = ['consumed_portions.consumed_at >= ? and consumed_portions.consumed_at < ?', Date.today() - 30, Date.today()]
  @@for_past = ['consumed_portions.consumed_at < ?', Date.today()]
  
end
