require 'test/unit'

def diff n, factor
  (n*factor).digits - n.digits
end

def solution
  factors = [2, 3, 4, 5, 6]
  n = 123_456
  while true
    results = []
    factors.each do |f|
      results.push diff(n, f).empty?
      break if results.last == false
    end
    break if results.all?

    n += 1
  end
  n
end

class TestPermutedMultiplesClass < Test::Unit::TestCase
  def test_125874
    n = 125874
    assert_empty(diff n, 2)
  end

  def test_solution
    puts "Solution: " << solution.to_s
  end
end