defmodule BridgeHandTest do
  use ExUnit.Case
  doctest Bridge.Hand

  setup do
    {:ok, %{
      club_suit: [140, 130, 110, 90, 70, 20], #AKJ972
      diamond_suit: [91, 71, 31] #973
    }}
  end

  describe "#generate_random" do
    test "it returns a valid hand one hundred times" do
      Enum.map(1..100, fn _ ->
        hand = Bridge.Hand.generate_random()
        n_cards = Enum.reduce(hand, 0, fn(suit, acc) -> length(suit) + acc end)

        assert length(hand) === 4
        assert n_cards === 13
        Enum.map(hand, fn suit ->
          assert Enum.uniq(suit) == suit
        end)
      end)
    end
  end

  describe "#to_s" do
    test "it returns the correct string of a valid hand" do
      hand = [
        [93, 83, 23],
        [142, 132, 102, 22],
        [131, 71],
        [130, 120, 110, 100],
      ]
      string = "S: 9 8 2\nH: A K T 2\nD: K 7\nC: K Q J T"

      assert Bridge.Hand.to_s(hand) == string
    end

    test "it returns the correct string of a hand with a void" do
      hand = [
        [130, 120, 110, 100, 80],
        [],
        [142, 132, 102, 22],
        [93, 83, 33, 23]
      ]

      string = "S: 9 8 3 2\nH: A K T 2\nD: --\nC: K Q J T 8"

      assert Bridge.Hand.to_s(hand) == string
    end
  end

  describe "#to_s_suit" do
    test "it returns the correct string of a suit with cards" do
      suit = [143, 103, 93, 83, 23]

      assert Bridge.Hand.to_s_suit(suit) == "A T 9 8 2"
    end

    test "it returns the correct string of a suit with no cards" do
      suit = []

      assert Bridge.Hand.to_s_suit(suit) == "--"
    end
  end

  describe "#hcp" do
    test "it returns correct sum of points of a hand with many honours" do
      hand = [
        [130, 120, 110, 100],
        [131, 71],
        [142, 132, 102, 22],
        [93, 83, 23]
      ]

      assert Bridge.Hand.hcp(hand) === 16
    end

    test "it returns 0 from a hand with no honours" do
      hand = [
        [90, 80, 20],
        [101, 91, 81, 21],
        [92, 82, 22],
        [93, 83, 23]
      ]

      assert Bridge.Hand.hcp(hand) === 0
    end
  end

  describe "#shape" do
    test "it returns the generalized shape of bridge hands" do
      hand1 = [ [90, 80, 20], [101, 91, 81, 21], [92, 82, 22], [93, 83, 23] ]
      hand2 = [ [70, 60, 30, 20], [91, 81, 71, 41, 31], [], [93, 83, 73, 23] ]

      assert Bridge.Hand.shape(hand1) == "4333"
      assert Bridge.Hand.shape(hand2) == "5440"
    end
  end

  describe "#true_shape" do
    test "it returns the shape regarding the suit order" do
      hand1 = [ [90, 80, 20], [101, 91, 81, 21], [92, 82, 22], [93, 83, 23] ]
      hand2 = [ [70, 60, 30, 20], [91, 81, 71, 41, 31], [], [93, 83, 73, 23] ]

      assert Bridge.Hand.true_shape(hand1) == "3343"
      assert Bridge.Hand.true_shape(hand2) == "4054"
    end
  end

  describe "#balanced?" do
    test "it returns true for a balanced hand and false otherwise" do
      hand1 = [ [90, 80, 20], [101, 91, 81, 21], [92, 82, 22], [93, 83, 23] ]
      hand2 = [ [70, 60, 30, 20], [91, 81, 71, 41, 31], [], [93, 83, 73, 23] ]

      assert Bridge.Hand.balanced?(hand1)
      refute Bridge.Hand.balanced?(hand2)
    end
  end

  describe "#suit_hcp" do
    test "it returns correct sum of points of hand with many honours",
      %{club_suit: suit} do
      # suit = [140, 130, 110, 90, 70, 20]

      assert Bridge.Hand.suit_hcp(suit) === 8
    end

    test "it returns 0 from suit without honours" do
      suit = [91, 71, 31]

      assert Bridge.Hand.suit_hcp(suit) === 0
    end

    test "it returns 0 from suit without any cards" do
      suit = []

      assert Bridge.Hand.suit_hcp(suit) === 0
    end
  end

  describe "#spades" do
    test "it returns how many spades in a hand" do
      hand = [ [90, 80, 70, 60, 20], [101, 91, 81, 21], [92, 82, 22], [93] ]

      assert Bridge.Hand.spades(hand) === 1
    end
  end

  describe "#hearts" do
    test "it returns how many hearts in a hand" do
      hand = [ [90, 80, 70, 60, 20], [101, 91, 81, 21], [92, 82, 22], [93] ]

      assert Bridge.Hand.hearts(hand) === 3
    end
  end

  describe "#diamonds" do
    test "it returns how many diamonds in a hand" do
      hand = [ [90, 80, 70, 60, 20], [101, 91, 81, 21], [92, 82, 22], [93] ]

      assert Bridge.Hand.diamonds(hand) === 4
    end
  end

  describe "#clubs" do
    test "it returns how many clubs in a hand" do
      hand = [ [90, 80, 70, 60, 20], [101, 91, 81, 21], [92, 82, 22], [93] ]

      assert Bridge.Hand.clubs(hand) === 5
    end
  end
end
