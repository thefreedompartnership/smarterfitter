class CopyConsumedPortionsIntoPortionsTableToCreateWeightPortions < ActiveRecord::Migration
  def self.up
    insert_statement = <<-INSERT_STATEMENT
      insert into portions (quantity, user_id, weight_id, consumed_at, created_at, modified_at, type)
        select quantity, user_id, weight_id, consumed_at, created_at, modified_at, 'WeightPortion' 
        from 
        consumed_portions
    INSERT_STATEMENT
    
    execute insert_statement
  end

  def self.down
    raise "This was a pretty destructive up and there's no down because we lost food_id in the process"
  end
end
