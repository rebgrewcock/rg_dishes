# frozen_string_literal: true

require_relative "rg_dishes/version"

require 'csv'

module RgDishes
  class Error < StandardError; end
  extend self

  #takes in dish name and returns its ingredients string.
  def dish_to_ingredients(dish_key, data)
    if data[dish_key.downcase]
      ingredients = data[dish_key.downcase].join(", ")
    else
      ingredients = nil
    end
    ingredients
  end

  #returns ingredients sentence from dish name and ingredients
  def construct_ingredients_sentence(ingredients, dish_arg)
    if ingredients
      ingredients_sentence = "Ingredients for #{dish_arg}: #{ingredients}."
    else
      ingredients_sentence = "I don't know the ingredients for #{dish_arg}."
    end
    ingredients_sentence
  end

  #takes in dish_arg, dish_key, returns ingredients sentence
  def dish_to_sentence(dish_arg, dish_key, data)
    ingredients = dish_to_ingredients(dish_key, data)
    sentence = construct_ingredients_sentence(ingredients, dish_arg)
    sentence
  end

  #returns the names of all dishes in hash
  def list_all_dishes(table)
    dishes = table.keys
    dishes
  end

  #returns hash{ingredient => number}
  def build_count_hash(ingredients)
    ing_num_hash = {}
    ingredients.each do |ingredient|
      if ing_num_hash[ingredient]
        ing_num_hash[ingredient] += 1
      else
        ing_num_hash[ingredient] = 1
      end
    end
    ing_num_hash
  end

  #returns array of strings for ingredients with number (where >2 dishes)
  def build_counted_dishes_array(ingredients_num_hash)
    ing_array = []
    ingredients_num_hash.each do |ingr, num|
      if num > 1
        ingr_string = ingr + " (*" + num.to_s + " dishes)"
      else
        ingr_string = ingr
      end
      ing_array << ingr_string
    end
    ing_array
  end

  def self.sentence_join(array)
    return nil if array.nil?
    return array[0] if array.length == 1
    return array[0..-2].join(', ') + " and " + array[-1] if array.length > 1
  end

  #returns shopping list array
  def make_shopping_list(ingr_array, no_ingr_dishes)
    ingredients_string = ingr_array.uniq.sort.join(",\n")
    shopping_list = []
    if !ingredients_string.empty?
      shopping_list << ingredients_string
    end
    if !no_ingr_dishes.empty?
      shopping_list << "I don't know the ingredients for #{sentence_join(no_ingr_dishes)}."
    end
    shopping_list
  end

  #----------------

  #reads csv into array of arrays.
  #doc = CSV.read("dishes.csv")

  def table_method
    doc = [["carbonara", "spaghetti", "bacon", "egg", "pecorino", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil], ["menemen", "egg", "pepper", "tomato", "bread", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil], ["sausages in a tray", "sausages", "sweet potato", "onion", "apple", "herbs", nil, nil, nil, nil, nil, nil, nil, nil, nil], ["stir fry", "noodles", "stir fry vegetables", "tofu", "fish sauce", "soy sauce", "garlic", "ginger", nil, nil, nil, nil, nil, nil, nil], ["spaghetti alle cozze", "spaghetti", "mussels", "white wine", "garlic", "chili flakes", "parsley", nil, nil, nil, nil, nil, nil, nil, nil], ["risotto", "risotto rice", "white wine", "stock", "herbs", "butter", nil, nil, nil, nil, nil, nil, nil, nil, nil], ["salmon en croute", "salmon", "pastry", "soft cheese", "lemon juice", "dill", "watercress", "egg", nil, nil, nil, nil, nil, nil, nil], ["grilled aubergine", "aubergine", "lemon", "garlic", "oregano", "basil", nil, nil, nil, nil, nil, nil, nil, nil, nil], ["aubergine parmigiana", "aubergine", "shallot", "garlic", "canned tomatoes", "basil", "parmesan", "chili flakes", nil, nil, nil, nil, nil, nil, nil], ["caramelized onion and blue cheese cups", "pastry", "red onion", "cider vinegar", "brown sugar", "blue cheese", "walnuts", "egg", nil, nil, nil, nil, nil, nil, nil], ["tuna steak", "tuna steak", "garlic", "ginger", "soy sauce", "orange juice", "lemon juice", nil, nil, nil, nil, nil, nil, nil, nil], ["roast potatoes", "potatoes", "herbs", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil], ["roast carrots and parsnips", "carrots", "parsnips", "honey", "thyme", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil], ["Hasselbach potatoes", "potatoes", "lemon", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil], ["roast chicken with a mustard glaze", "chicken", "garlic", "rosemary", "mustard", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil], ["roast chicken with apple and brandy", "chicken", "garlic", "brandy", "apple juice", "onion", nil, nil, nil, nil, nil, nil, nil, nil, nil], ["baked sardines", "sardines", "garlic", "herbs", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil], ["Beef Wellington", "fillet steak", "shallot", "chestnut mushrooms", "porcini mushrooms", "butter", "thyme", "white wine", "prosciutto", "pastry", "egg", "bay leaf", "stock", "brandy", "red wine"], ["glazed salmon", "salmon", "brown sugar", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil], ["pesto", "pine nuts", "garlic", "basil", "parmesan", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil], ["Ratatouille", "aubergine", "pepper", "courgette", "tomato", "onion", "garlic", "basil", "thyme", "lemon", "cumin", nil, nil, nil, nil]]

    #transforms array of arrays into a hash.
    table = {}
    doc.each do |array|
      table[array.shift] = array.compact
    end

    #transforms all keys in hash to lower case.
    table.transform_keys!(&:downcase)
    table
  end

  #----------------

  #dinner inspire returns all dishes in hash
  def inspire
    table = table_method
    list_all_dishes(table).join("\n")
  end

  #----------------

  #dinner combine returns ingredients for all dishes
  def combine(dish_array)
    table = table_method
    if dish_array.nil? or dish_array.empty?
      "Please include a dishy argument."
    else
      ingredients = []
      no_ingredients_dishes = []
      dish_array.each do |dish_element|
        arg_string = dish_element.downcase
        if table[arg_string]
          #concat makes array rather than array of arrays
          ingredients.concat(table[arg_string])
        else
          no_ingredients_dishes << dish_element
        end
      end

      #builds hash to count ingredients
      ingredients_num_hash = build_count_hash(ingredients)

      #appends number to repeated ingredients
      ingredients_array = build_counted_dishes_array(ingredients_num_hash)

      #builds shopping list
      shopping_list = make_shopping_list(ingredients_array, no_ingredients_dishes).join("\n\n")

      #returns shopping list_all_dishes
      shopping_list
    end
  end

  #----------------

end
