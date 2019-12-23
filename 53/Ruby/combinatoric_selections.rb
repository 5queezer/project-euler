# projecteuler.net problem 53
# ruby combinatoric_selections.rb

class Factorial
  attr_reader :factors

  def initialize n
    @factors = *(2..n) if n.is_a? Integer
    @factors = n       if n.is_a? Array
    raise Exception unless defined?(@factors)
  end

  def get_value
    @factors.empty? ? 1 : @factors.inject(:*)
  end

  def cancel(other)
    raise Exception if other.factors.size > factors.size
    Factorial.new @factors - other.factors
  end

  def *(other)
    Factorial.new @factors + other.factors
  end
end

def combinatoric(n, r)
  fr = Factorial.new(r)
  nr = Factorial.new(n - r)

  if fr.factors.size > nr.factors.size
    nom = Factorial.new(n).cancel(fr)
    denom = nr
  else
    nom = Factorial.new(n).cancel(nr)
    denom = fr
  end

  nom.get_value / denom.get_value
end

if $0 == __FILE__
  hits = 0
  (1..100).each do |n|
    (1..n).each do |r|
      value = combinatoric(n, r)
      hits += 1 if value > 1e6
    end
  end
  puts hits
end
