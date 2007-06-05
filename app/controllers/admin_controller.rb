class AdminController < ApplicationController
  
  def load_database
    load_food_groups
    load_foods
    load_weights
    load_nutrients
    load_food_nutrients
  end
  
  def load_food_groups
    File.open("db/sr19/FD_GROUP.txt") do |file|
      while line = file.gets
        fields = line.split("^")
        FoodGroup.create(
          :code => fields[0].delete("~"),
          :description => fields[1].delete("~")
        )
      end 
    end   
  end     


  def load_foods
    File.open("db/sr19/FOOD_DES.txt") do |file|
      while line = file.gets
        fields = line.split("^")
        food = Food.new(
          :ndb_number => fields[0].delete("~"),
          :food_group_code => fields[1].delete("~"),
          :long_description => fields[2].delete("~"),
          :short_description => fields[3].delete("~"),
          :common_name => fields[4].delete("~"),
          :manufacturer_name => fields[5].delete("~"),
          :survey => fields[6].delete("~"),
          :refuse_description => fields[7].delete("~"),
          :refuse_percentage => fields[8].to_i,
          :scientific_name => fields[9].delete("~"),
          :nitrogen_factor => fields[10].to_f,
          :protein_factor => fields[11].to_f,
          :fat_factor => fields[12].to_f,
          :cho_factor => fields[13].to_f
        )
        food_group = FoodGroup.find_by_code(food.food_group_code)
        food_group.foods << food
      end 
    end   
  end     
  
  def load_weights
    File.open("db/sr19/WEIGHT.txt") do |file|
      while line = file.gets
        fields = line.split("^")
        weight = Weight.new(
          :ndb_number => fields[0].delete("~"),
          :sequence => fields[1].delete("~").to_i,
          :amount => fields[2].to_f,
          :measure_description => fields[3].delete("~"),
          :weight_in_grams => fields[4].to_f,
          :number_of_data_points => fields[5].to_i,
          :standard_deviation => fields[6].to_f
        )
        food = Food.find_by_ndb_number(weight.ndb_number)
        food.weights << weight
      end 
    end   
  end
  
  def load_nutrients
    File.open("db/sr19/NUTR_DEF.txt") do |file|
      while line = file.gets
        fields = line.split("^")
        Nutrient.create(
          :nutrient_number => fields[0].delete("~"),
          :units => fields[1].delete("~"),
          :infoods_tagname => fields[2].delete("~"),
          :nutrient_description => fields[3].delete("~"),
          :decimal_places_rounded_to => fields[4].delete("~"),
          :sort_order => fields[5].to_i
        )
      end 
    end   
  end     

  def load_food_nutrients
    File.open("db/sr19/NUT_DATA.txt") do |file|
      i = 0
      
      create_start = start = Time.now
      while line = file.gets
        fields = line.split("^")
        food_nutrient = FoodNutrient.create(
          :ndb_number => fields[0].delete("~"),
          :nutrient_number => fields[1].delete("~"),
          :nutrient_value => fields[2].to_f,
          :number_of_data_points => fields[3].to_i,
          :standard_error => fields[4].to_f,
          :source_code => fields[5].delete("~"),
          :derivation_code => fields[6].delete("~"),
          :reference_ndb_number => fields[7].delete("~"),
          :is_added_nutrient => fields[8].delete("~"),
          :number_of_studies => fields[9].to_i,
          :minimum_value => fields[10].to_f,
          :maximum_value => fields[11].to_f,
          :degrees_of_freedom => fields[12].to_i,
          :lower_error_bound => fields[13].to_f,
          :upper_error_bound => fields[14].to_f,
          :statistical_comments => fields[15].delete("~"),
          :confidence_code => fields[16].delete("~")
        )
        if(i.modulo(100) == 0)
          finish = Time.now
          puts "FoodNutrient: #{i} processed in #{finish - start} seconds"
          start = Time.now
        end
        i = i + 1
      end
      
      puts "FoodNutrient creation too #{Time.now - create_start} seconds"
      
      update_start = Time.now
      FoodNutrient.connection.execute("UPDATE food_nutrients fn, foods f, nutrients n " +
                                      "SET fn.food_id = f.id, fn.nutrient_id = n.id " +
                                      "WHERE fn.ndb_number = f.ndb_number " + 
                                      "AND fn.nutrient_number = n.nutrient_number")
      puts "Time taken for update: #{Time.now - update_start}"
    end   
    
    
end 
    
end      
                   
                   
    
    