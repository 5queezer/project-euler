

class Prime < Integer
  def is_prime? n
    for d in 2..(n - 1)
      return false if n % d == 0
    end
    true
  end
end

def sieve max
  sieve = [nil, nil]
  for d in 2..max
    sieve.push d.is_prime?
  end
end