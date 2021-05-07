defmodule BridgeSuitTest do
  use ExUnit.Case
  doctest Bridge.Suit

  setup do
    {:ok,
     %{
       # AKJ972
       club_suit: [140, 130, 110, 90, 70, 20],
       # 973
       diamond_suit: [91, 71, 31]
     }}
  end

  describe "#to_s" do
    test "it returns the correct string of a suit with cards" do
      suit = [143, 103, 93, 83, 23]

      assert Bridge.Suit.to_s(suit) == "A T 9 8 2"
    end

    test "it returns the correct string of a suit without cards" do
      suit = []

      assert Bridge.Suit.to_s(suit) == "--"
    end
  end

  describe "#hcp" do
    test "it returns correct sum of points of a suit with honours",
         %{club_suit: suit} do
      # suit = [140, 130, 110, 90, 70, 20]

      assert Bridge.Suit.hcp(suit) === 8
    end

    test "it returns 0 from suit without honours" do
      suit = [91, 71, 31]

      assert Bridge.Suit.hcp(suit) === 0
    end

    test "it returns 0 from suit without cards" do
      suit = []

      assert Bridge.Suit.hcp(suit) === 0
    end
  end
end
