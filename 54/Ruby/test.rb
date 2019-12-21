require_relative 'p54'
require 'test/unit'

class TestHands < Test::Unit::TestCase
  def test_royal_flush
    hand = Hand.new "8C TC KC 9C 4C"
    assert_false hand.is_royal_flush?

    hand = Hand.new "TC JC QC KC AC"
    assert_true hand.is_royal_flush?
  end

  def test_straight_flush
    hand = Hand.new "4C 5C 6C 7C TC"
    assert_false hand.is_straight_flush?

    hand = Hand.new "6C 5C 4C 7C 8C"
    assert_true hand.is_straight_flush?
  end

  def test_four_of_a_kind
    hand = Hand.new "4C 4D KC TS 4H"
    assert_false hand.is_four_of_a_kind?

    hand = Hand.new "4C 4D KC 4S 4H"
    assert_true hand.is_four_of_a_kind?
  end

  def test_full_house
    hand = Hand.new "4D 2C KC 7S TC"
    assert_false hand.is_full_house?

    hand = Hand.new "4C 2C KC 7S TC"
    assert_false hand.is_full_house?

    hand = Hand.new "4C 2C KS 7S TC"
    assert_true hand.is_full_house?
  end

  def test_flush
    hand = Hand.new "4C 2C KS 7S TC"
    assert_false hand.is_flush?

    hand = Hand.new "4C 2C KC 7C TC"
    assert_true hand.is_flush?
  end

  def test_straight
    hand = Hand.new "2S 8D 8C 4C TS"
    assert_false hand.is_straight?

    hand = Hand.new "6S 7D 8C 9C TS"
    assert_true hand.is_straight?
  end

  def test_three_of_a_kind
    hand = Hand.new "2S 8D 2C 4C TS"
    assert_false hand.is_three_of_a_kind?

    hand = Hand.new "6S TD TC 6C TS"
    assert_false hand.is_three_of_a_kind?

    hand = Hand.new "6S TD TC 8C TS"
    assert_true hand.is_three_of_a_kind?
  end

  def two_pairs
    hand = Hand.new "6H TD 9D AS JH"
    assert_false hand.is_two_pairs?

    hand = Hand.new "6H JD 9D 6S JH"
    assert_true hand.is_two_pairs?
  end

  def one_pair
    hand = Hand.new "6H JD 9D 6S JH"
    assert_false hand.is_one_pair?

    hand = Hand.new "6H TD 9D 6S JH"
    assert_true hand.is_one_pair?
  end
end

class TestHandsCompare < Test::Unit::TestCase
  def test_pair_of_fives
    h1 = Hand.new "5H 5C 6S 7S KD"
    h2 = Hand.new "2C 3S 8S 8D TD"
  end

  def test_highest_card
    h1 = Hand.new "5D 8C 9S JS AC"
    h2 = Hand.new "2C 5C 7D 8S QH"

    assert_compare h1, ">", h2
  end
end