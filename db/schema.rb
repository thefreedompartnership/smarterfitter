# This file is autogenerated. Instead of editing this file, please use the
# migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.

ActiveRecord::Schema.define(:version => 26) do

  create_table "body_masses", :force => true do |t|
    t.column "mass",        :decimal,  :precision => 6, :scale => 2
    t.column "recorded_at", :datetime
    t.column "created_at",  :datetime
    t.column "modified_at", :datetime
    t.column "user_id",     :integer
  end

  create_table "chains", :force => true do |t|
    t.column "name",       :string
    t.column "key",        :string
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "time_zone",  :string
    t.column "read_key",   :string
  end

  add_index "chains", ["key"], :name => "index_chains_on_key", :unique => true
  add_index "chains", ["read_key"], :name => "index_chains_on_read_key", :unique => true

  create_table "consumed_portions", :force => true do |t|
    t.column "created_at",  :datetime
    t.column "modified_at", :datetime
    t.column "quantity",    :decimal,  :precision => 8, :scale => 3
    t.column "weight_id",   :integer
    t.column "food_id",     :integer
    t.column "user_id",     :integer
    t.column "consumed_at", :datetime
  end

  create_table "days", :force => true do |t|
    t.column "when",       :date
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "chain_id",   :integer
  end

  add_index "days", ["when"], :name => "index_days_on_when"

  create_table "food_groups", :force => true do |t|
    t.column "code",        :string
    t.column "description", :string
  end

  create_table "food_nutrients", :force => true do |t|
    t.column "ndb_number",            :string
    t.column "nutrient_number",       :string
    t.column "nutrient_value",        :decimal,  :precision => 10, :scale => 3
    t.column "number_of_data_points", :integer
    t.column "standard_error",        :decimal,  :precision => 8,  :scale => 3
    t.column "source_code",           :string
    t.column "derivation_code",       :string
    t.column "reference_ndb_number",  :string
    t.column "is_added_nutrient",     :string
    t.column "number_of_studies",     :integer
    t.column "minimum_value",         :decimal,  :precision => 10, :scale => 3
    t.column "maximum_value",         :decimal,  :precision => 10, :scale => 3
    t.column "degrees_of_freedom",    :integer
    t.column "lower_error_bound",     :decimal,  :precision => 10, :scale => 3
    t.column "upper_error_bound",     :decimal,  :precision => 10, :scale => 3
    t.column "statistical_comments",  :string
    t.column "confidence_code",       :string
    t.column "food_id",               :integer
    t.column "nutrient_id",           :integer
    t.column "created_at",            :datetime
    t.column "modified_at",           :datetime
  end

  add_index "food_nutrients", ["food_id"], :name => "index_food_nutrients_on_food_id"
  add_index "food_nutrients", ["nutrient_id"], :name => "index_food_nutrients_on_nutrient_id"
  add_index "food_nutrients", ["ndb_number"], :name => "index_food_nutrients_on_ndb_number"
  add_index "food_nutrients", ["nutrient_number"], :name => "index_food_nutrients_on_nutrient_number"

  create_table "foods", :force => true do |t|
    t.column "ndb_number",         :string
    t.column "food_group_code",    :string
    t.column "long_description",   :string
    t.column "short_description",  :string
    t.column "common_name",        :string
    t.column "manufacturer_name",  :string
    t.column "survey",             :string
    t.column "refuse_description", :string
    t.column "refuse_percentage",  :integer
    t.column "scientific_name",    :string
    t.column "nitrogen_factor",    :decimal,  :precision => 4, :scale => 2
    t.column "protein_factor",     :decimal,  :precision => 4, :scale => 2
    t.column "fat_factor",         :decimal,  :precision => 4, :scale => 2
    t.column "cho_factor",         :decimal,  :precision => 4, :scale => 2
    t.column "food_group_id",      :integer
    t.column "created_at",         :datetime
    t.column "updated_at",         :datetime
  end

  add_index "foods", ["ndb_number"], :name => "index_foods_on_ndb_number"

  create_table "link_suggestions", :force => true do |t|
    t.column "name",          :string
    t.column "email_address", :string
    t.column "website",       :string
    t.column "title",         :string
    t.column "link",          :string
    t.column "description",   :text
    t.column "created_at",    :datetime
    t.column "updated_at",    :datetime
  end

  create_table "nutrients", :force => true do |t|
    t.column "nutrient_number",           :string
    t.column "units",                     :string
    t.column "infoods_tagname",           :string
    t.column "nutrient_description",      :string
    t.column "decimal_places_rounded_to", :integer
    t.column "sort_order",                :integer
    t.column "created_at",                :datetime
    t.column "modified_at",               :datetime
  end

  add_index "nutrients", ["nutrient_number"], :name => "index_nutrients_on_nutrient_number"

  create_table "portions", :force => true do |t|
    t.column "quantity",    :decimal,  :precision => 8, :scale => 3
    t.column "created_at",  :datetime
    t.column "modified_at", :datetime
    t.column "user_id",     :integer
    t.column "recipe_id",   :integer
    t.column "weight_id",   :integer
    t.column "type",        :string
    t.column "consumed_at", :datetime
  end

  create_table "recipes", :force => true do |t|
    t.column "servings",     :integer
    t.column "description",  :string
    t.column "instructions", :text
    t.column "created_at",   :datetime
    t.column "modified_at",  :datetime
    t.column "user_id",      :integer
    t.column "is_deleted",   :boolean,  :default => false
  end

  create_table "runs", :force => true do |t|
    t.column "user_id",             :integer
    t.column "when_run",            :datetime
    t.column "distance_in_meters",  :integer
    t.column "distance_unit",       :string
    t.column "duration_in_seconds", :integer
    t.column "route",               :string
    t.column "description",         :text
    t.column "route_points",        :text
  end

  create_table "users", :force => true do |t|
    t.column "user_name",          :string
    t.column "email_address",      :string
    t.column "hashed_password",    :string
    t.column "first_name",         :string
    t.column "last_name",          :string
    t.column "measurement_system", :string
    t.column "time_zone",          :string
    t.column "default_latitude",   :string
    t.column "default_longitude",  :string
    t.column "default_zoom",       :string
  end

  create_table "weights", :force => true do |t|
    t.column "ndb_number",            :string
    t.column "sequence",              :integer
    t.column "amount",                :decimal,  :precision => 8, :scale => 3
    t.column "measure_description",   :string
    t.column "weight_in_grams",       :decimal,  :precision => 7, :scale => 1
    t.column "number_of_data_points", :integer
    t.column "standard_deviation",    :decimal,  :precision => 7, :scale => 3
    t.column "food_id",               :integer
    t.column "created_at",            :datetime
    t.column "modified_at",           :datetime
  end

end
