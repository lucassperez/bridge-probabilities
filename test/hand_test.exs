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
        [130, 120, 110, 100],
        [131, 71],
        [142, 132, 102, 22],
        [93, 83, 23]
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
        [93, 83, 23],
        [142, 132, 102, 22],
        [131, 71],
        [130, 120, 110, 100]
      ]

      assert Bridge.Hand.hcp(hand) === 16
    end

    test "it returns 0 from a hand with no honours" do
      hand = [
        [93, 83, 23],
        [92, 82, 22],
        [101, 91, 81, 21],
        [90, 80, 20]
      ]

      assert Bridge.Hand.hcp(hand) === 0
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
end
