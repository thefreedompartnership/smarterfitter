# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 26) do

  create_table "body_masses", :force => true do |t|
    t.decimal  "mass",        :precision => 6, :scale => 2
    t.datetime "recorded_at"
    t.datetime "created_at"
    t.datetime "modified_at"
    t.integer  "user_id"
  end

  create_table "chains", :force => true do |t|
    t.string   "name"
    t.string   "key"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "time_zone"
    t.string   "read_key"
  end

  add_index "chains", ["key"], :name => "index_chains_on_key", :unique => true
  add_index "chains", ["read_key"], :name => "index_chains_on_read_key", :unique => true

  create_table "consumed_portions", :force => true do |t|
    t.datetime "created_at"
    t.datetime "modified_at"
    t.decimal  "quantity",    :precision => 8, :scale => 3
    t.integer  "weight_id"
    t.integer  "food_id"
    t.integer  "user_id"
    t.datetime "consumed_at"
  end

  create_table "days", :force => true do |t|
    t.date     "when"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "chain_id"
  end

  add_index "days", ["when"], :name => "index_days_on_when"

  create_table "food_groups", :force => true do |t|
    t.string "code"
    t.string "description"
  end

  create_table "food_nutrients", :force => true do |t|
    t.string   "ndb_number"
    t.string   "nutrient_number"
    t.decimal  "nutrient_value",        :precision => 10, :scale => 3
    t.integer  "number_of_data_points"
    t.decimal  "standard_error",        :precision => 8,  :scale => 3
    t.string   "source_code"
    t.string   "derivation_code"
    t.string   "reference_ndb_number"
    t.string   "is_added_nutrient"
    t.integer  "number_of_studies"
    t.decimal  "minimum_value",         :precision => 10, :scale => 3
    t.decimal  "maximum_value",         :precision => 10, :scale => 3
    t.integer  "degrees_of_freedom"
    t.decimal  "lower_error_bound",     :precision => 10, :scale => 3
    t.decimal  "upper_error_bound",     :precision => 10, :scale => 3
    t.string   "statistical_comments"
    t.string   "confidence_code"
    t.integer  "food_id"
    t.integer  "nutrient_id"
    t.datetime "created_at"
    t.datetime "modified_at"
  end

  add_index "food_nutrients", ["food_id"], :name => "index_food_nutrients_on_food_id"
  add_index "food_nutrients", ["nutrient_id"], :name => "index_food_nutrients_on_nutrient_id"
  add_index "food_nutrients", ["ndb_number"], :name => "index_food_nutrients_on_ndb_number"
  add_index "food_nutrients", ["nutrient_number"], :name => "index_food_nutrients_on_nutrient_number"

  create_table "foods", :force => true do |t|
    t.string   "ndb_number"
    t.string   "food_group_code"
    t.string   "long_description"
    t.string   "short_description"
    t.string   "common_name"
    t.string   "manufacturer_name"
    t.string   "survey"
    t.string   "refuse_description"
    t.integer  "refuse_percentage"
    t.string   "scientific_name"
    t.decimal  "nitrogen_factor",    :precision => 4, :scale => 2
    t.decimal  "protein_factor",     :precision => 4, :scale => 2
    t.decimal  "fat_factor",         :precision => 4, :scale => 2
    t.decimal  "cho_factor",         :precision => 4, :scale => 2
    t.integer  "food_group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "foods", ["ndb_number"], :name => "index_foods_on_ndb_number"

  create_table "link_suggestions", :force => true do |t|
    t.string   "name"
    t.string   "email_address"
    t.string   "website"
    t.string   "title"
    t.string   "link"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nutrients", :force => true do |t|
    t.string   "nutrient_number"
    t.string   "units"
    t.string   "infoods_tagname"
    t.string   "nutrient_description"
    t.integer  "decimal_places_rounded_to"
    t.integer  "sort_order"
    t.datetime "created_at"
    t.datetime "modified_at"
  end

  add_index "nutrients", ["nutrient_number"], :name => "index_nutrients_on_nutrient_number"

  create_table "portions", :force => true do |t|
    t.decimal  "quantity",    :precision => 8, :scale => 3
    t.datetime "created_at"
    t.datetime "modified_at"
    t.integer  "user_id"
    t.integer  "recipe_id"
    t.integer  "weight_id"
    t.string   "type"
    t.datetime "consumed_at"
  end

  create_table "recipes", :force => true do |t|
    t.integer  "servings"
    t.string   "description"
    t.text     "instructions"
    t.datetime "created_at"
    t.datetime "modified_at"
    t.integer  "user_id"
    t.boolean  "is_deleted",   :default => false
  end

  create_table "runs", :force => true do |t|
    t.integer  "user_id"
    t.datetime "when_run"
    t.integer  "distance_in_meters"
    t.string   "distance_unit"
    t.integer  "duration_in_seconds"
    t.string   "route"
    t.text     "description"
    t.text     "route_points"
  end

  create_table "users", :force => true do |t|
    t.string "user_name"
    t.string "email_address"
    t.string "hashed_password"
    t.string "first_name"
    t.string "last_name"
    t.string "measurement_system"
    t.string "time_zone"
    t.string "default_latitude"
    t.string "default_longitude"
    t.string "default_zoom"
  end

  create_table "weights", :force => true do |t|
    t.string   "ndb_number"
    t.integer  "sequence"
    t.decimal  "amount",                :precision => 8, :scale => 3
    t.string   "measure_description"
    t.decimal  "weight_in_grams",       :precision => 7, :scale => 1
    t.integer  "number_of_data_points"
    t.decimal  "standard_deviation",    :precision => 7, :scale => 3
    t.integer  "food_id"
    t.datetime "created_at"
    t.datetime "modified_at"
  end

end
