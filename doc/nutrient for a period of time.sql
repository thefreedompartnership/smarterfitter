SELECT SUM(total) AS total FROM (

      SELECT SUM(fn.nutrient_value * ((p.quantity / w.amount)  
          * (w.weight_in_grams / 100))) AS total 
      FROM portions p, weights w, food_nutrients fn 
      WHERE w.id = p.weight_id 
        AND fn.food_id = w.food_id 
        AND fn.nutrient_number = 208
        AND user_id = 1
        AND p.type = 'WeightPortion'
        AND p.consumed_at >= '2007-11-10 00:00:00'
        AND p.consumed_at <  '2007-11-11 00:00:00'

    UNION

      SELECT SUM((fn.nutrient_value * ((p.quantity / w.amount)
          * (w.weight_in_grams / 100)) 
          / r.servings) * recipes_consumed.servings_consumed) AS total 
      FROM portions AS p, weights AS w, food_nutrients AS fn, recipes AS r,
      (SELECT p.id AS recipe_portion_id, p.quantity AS servings_consumed, p.recipe_id recipe_consumed
          FROM portions p
          WHERE p.type = 'RecipePortion'
          AND p.user_id = 1
          AND p.consumed_at >= '2007-11-10 00:00:00'
          AND p.consumed_at <  '2007-11-11 00:00:00') AS recipes_consumed
      
      WHERE p.type = 'IngredientPortion'
      AND w.id = p.weight_id
      AND fn.food_id = w.food_id 
      AND fn.nutrient_number = 208 
      AND p.recipe_id = r.id
      AND r.id = recipes_consumed.recipe_consumed
) AS totals
