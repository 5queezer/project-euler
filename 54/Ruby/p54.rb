require 'open-uri'

HANDS_FILE = "p054_poker.txt"

class Hand
  def initialize(cards)
    cards = cards.split if cards.is_a? String
    abort("5 cards expected") unless cards.length == 5
    @values = cards.map{ |c| value_of c[0] }
    @colors = cards.map{ |c| c[1] }
    @occurrences = @values.group_by(&:itself).transform_values(&:count)
    @occurrences = @occurrences.sort_by(&:first).sort_by(&:last).reverse
  end

  def >(other)
    ranking_methods = %w[ is_one_pair?
                          is_two_pairs?
                          is_three_of_a_kind?
                          is_straight?
                          is_flush?
                          is_full_house?
                          is_four_of_a_kind?
                          is_straight_flush?
                          is_royal_flush?
    ]

    ranking_methods.reverse.each do |method|
      r1 = self.send(method)
      r2 = other.send(method)
      return comp_high_card(other) if r1 && r2
      return true if r1
      return false if r2
    end

    comp_high_card(other)
  end

  def <(other)
    not self > other
  end

  def value_of(c)
    lookup = { :T => 10, :J => 11, :Q => 12, :K => 13, :A => 14 }
    lookup.each_pair do |k, v|
      return v if c == k.to_s
    end
    c.to_i
  end

  def is_one_pair?
    @occurrences[0].last == 2 && @occurrences[1]&.last == 1
  end

  def is_two_pairs?
    @occurrences[0].last == 2 && @occurrences[1]&.last == 2
  end

  def is_three_of_a_kind?
    @occurrences[0].last == 3 && @occurrences[1]&.last == 1
  end

  def is_straight?
    @values.uniq.size == 5 && @values.sort.each_cons(2).all? { |x,y| y == x + 1 }
  end

  def is_flush?
    @colors.uniq.size == 1
  end

  def is_full_house?
    @occurrences[0].last == 3 && @occurrences[1]&.last == 2
  end

  def is_four_of_a_kind?
    @occurrences[0].last == 4
  end

  def is_straight_flush?
    return false unless is_flush?
    diff = Array(@values.min..@values.max) - @values
    diff.size.zero?
  end

  def is_royal_flush?
    is_straight_flush? and high_cards[0] == value_of("A")
  end

  def high_cards
    @occurrences.map(&:first)
  end

  def comp_high_card (other)
    high_cards.zip(other.high_cards).each do |hc1, hc2|
      next if hc1 == hc2
      return hc1 > hc2
    end
  end
end


if $0 == __FILE__
  open(HANDS_FILE, 'w') do |file|
    # cache the file
    file << open("https://projecteuler.net/project/resources/#{HANDS_FILE}").read
  end unless File.file?(HANDS_FILE)

  wins1 = 0
  open(HANDS_FILE).read.each_line do |hands|
    hands = hands.split
    pl1 = Hand.new hands[0..4]
    pl2 = Hand.new hands[5..9]
    wins1 += 1 if pl1 > pl2
  end
  puts wins1
end