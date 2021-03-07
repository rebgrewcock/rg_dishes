# frozen_string_literal: true

require "test_helper"

class RgDishesTest < Minitest::Test
  def test_inspire_returns_something
    output = inspire
    refute output.empty?
  end

  def test_inspire_returns_string
    output = inspire
    assert_equal "String", output.class
  end

  def test_combine_with_known_dish
    output = combine(["carbonara", "menemen"])
    assert_equal "bacon
                  bread
                  egg (*2 dishes)
                  pecorino
                  pepper
                  spaghetti
                  tomato", output
  end

  def test_combine_with_unknown_dish
    output = combine(["bob"])
    assert_equal "I don't know the ingredients for bob.", output
  end

  def test_combine_known_and_unknown
    output = combine(["carbonara", "bob"])
    assert_equal "bacon
                  egg
                  pecorino
                  spaghetti
                  I don't know the ingredients for bob.", output
  end

  def test_combine_no_dishes
    output = combine("")
    assert_equal "Please include a dishy argument.", output
  end
end
