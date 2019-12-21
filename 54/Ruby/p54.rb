require 'open-uri'

HANDS_FILE = "p054_poker.txt"

class Hand
  attr_reader :values
  def initialize(cards)
    cards = cards.split if cards.is_a? String
    abort("5 cards expected") unless cards.length == 5
    @values = cards.map{ |c| value_of c }
    @colors = cards.map{ |c| c[1] }
  end

  def >(other)
    return true if is_royal_flush?
    # todo comparison

    self.high_card > other.high_card
  end

  def value_of(card)
    lookup = { "T" => 10, "J" => 11, "Q" => 12, "K" => 13, "A" => 14 }
    lookup.each_pair do |k, v|
      return v if card[0] == k
    end
    card[0].to_i
  end

  def high_card
    @values.max
  end

  def is_one_pair?
    @values.uniq.size == 4
  end

  def is_two_pairs?
    h = @values.group_by(&:itself).transform_values(&:count).sort_by(&:last)
    h[0][1] == 2 && h[1][1] == 2
  end

  def is_three_of_a_kind?
    @values.uniq.size == 3
  end

  def is_straight?
    high_card == @values.min + 4
  end

  def is_flush?
    @colors.uniq.size == 1
  end

  def is_full_house?
    h = @colors.group_by(&:itself).transform_values(&:count).sort_by(&:last)
    h[0][1] == 2 and h[1][1] == 3
  end

  def is_four_of_a_kind?
    @values.uniq.size == 2
  end

  def is_straight_flush?
    return false unless is_flush?
    diff = @values - Array(high_card-5..high_card)
    diff.size == 0
  end

  def is_royal_flush?
    return false unless is_flush?
    is_straight_flush? and high_card == value_of("A")
  end
end


if $0 == __FILE__
  open(HANDS_FILE, 'w') do |file|
    # cache the file
    file << open("https://projecteuler.net/project/resources/#{HANDS_FILE}").read
  end unless File.file?(HANDS_FILE)

  open(HANDS_FILE).read.each_line do |hands|
    hands = hands.split
    pl1 = Hand.new(hands[0..4])
    pl2 = Hand.new(hands[5..9])

    break
  end
end