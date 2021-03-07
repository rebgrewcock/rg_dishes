# frozen_string_literal: true

require "test_helper"

class RgDishesTest < Minitest::Test
  def test_inspire_returns_something
    output = RgDishes::inspire
    refute output.empty?
  end

  def test_inspire_returns_string
    output = RgDishes::inspire
    assert_equal String, output.class
  end

  def test_combine_with_known_dish
    output = RgDishes::combine(["carbonara", "menemen"])
    assert_equal "bacon\nbread\negg (*2 dishes)\npecorino\npepper\nspaghetti\ntomato", output
  end

  def test_combine_with_unknown_dish
    output = RgDishes::combine(["bob"])
    assert_equal "I don't know the ingredients for bob.", output
  end

  def test_combine_known_and_unknown
    output = RgDishes::combine(["carbonara", "bob"])
    assert_equal "bacon\negg\npecorino\nspaghetti\nI don't know the ingredients for bob.", output
  end

  def test_combine_no_dishes
    output = RgDishes::combine("")
    assert_equal "Please include a dishy argument.", output
  end
end
