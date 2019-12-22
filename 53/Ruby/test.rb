require_relative 'combinatoric_selections'
require 'test/unit'

class TestFactorialClass < Test::Unit::TestCase
  def test_cancel
    f1 = Factorial.new 5
    f2 = Factorial.new 3
    res = f1.cancel(f2)
    assert_equal res.get_value, 20
  end

  def test_multiply
    f1 = Factorial.new 2
    f2 = Factorial.new 3
    res = f1 * f2
    assert_equal res.get_value, 12
  end

  def test_fraction_example1
    assert_equal combinatoric(5, 3), 10
  end

  def test_fraction_example2
    assert_equal combinatoric(23, 10), 1144066
  end
end