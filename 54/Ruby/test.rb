require_relative 'poker'
require 'test/unit'

HANDS_FILE = "p054_poker.txt"

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
    assert_false hand.is_full_house?

    hand = Hand.new "2H 2D 4C 4D 4S"
    assert_true hand.is_full_house?

    hand = Hand.new "3C 3D 3S 9S 9D"
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

    hand = Hand.new "8D 3S 5D 5C AH"
    assert_false hand.is_straight?

    hand = Hand.new "9H 4D JC KS JS"
    assert_false hand.is_straight?

    hand = Hand.new "6S 7D 8C 9C TS".split.shuffle
    assert_true hand.is_straight?
  end

  def test_three_of_a_kind
    hand = Hand.new "2S 8D 2C 4C TS"
    assert_false hand.is_three_of_a_kind?

    hand = Hand.new "6S TD TC 6C TS"
    assert_false hand.is_three_of_a_kind?
  end

  def two_pairs
    hand = Hand.new "6H TD 9D AS JH"
    assert_false hand.is_two_pairs?

    hand = Hand.new "6H JD 9D 6S JH"
    assert_true hand.is_two_pairs?
  end

  def test_one_pair
    hand = Hand.new "6H JD 9D 6S JH"
    assert_false hand.is_one_pair?

    hand = Hand.new "6H TD 9D 6S JH"
    assert_true hand.is_one_pair?
  end

  def test_equal_hands
    hand1 = Hand.new "3C 3D 3S 9S 9D"
    hand2 = Hand.new "3D 3H 3S 9S 9C"
    assert_raise do
      hand1 > hand2
    end
  end
end

class TestHandsCompare < Test::Unit::TestCase
  def test_1
    h1 = Hand.new "5H 5C 6S 7S KD"
    h2 = Hand.new "2C 3S 8S 8D TD"
    assert_compare h1, "<", h2
  end

  def test_2
    h1 = Hand.new "5D 8C 9S JS AC"
    h2 = Hand.new "2C 5C 7D 8S QH"
    assert_compare h1, ">", h2
  end

  def test_3
    h1 = Hand.new "2D 9C AS AH AC"
    h2 = Hand.new "3D 6D 7D TD QD"
    assert_compare h1, "<", h2
  end

  def test_4
    h1 = Hand.new "4D 6S 9H QH QC"
    h2 = Hand.new "3D 6D 7H QD QS"
    assert_compare h1, ">", h2
  end

  def test_5
    h1 = Hand.new "2H 2D 4C 4D 4S"
    h2 = Hand.new "3C 3D 3S 9S 9D"
    assert_compare h1, ">", h2
  end

  def test_end
    wins = read_stream File.open(HANDS_FILE)
    assert_equal wins[0], 376
  end
end
