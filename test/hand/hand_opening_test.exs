defmodule BridgeHandOpeningTest do
  use ExUnit.Case
  doctest Bridge.Hand.Opening

  describe "#strong_nt?" do
    test "it returns true if a hand has 15-17 points and is balanced" <>
         "(5M possible)" do
      hand1 = [[143, 133, 23], [142, 82, 22], [121, 101, 81, 21], [120, 80, 20]]
      hand2 = [[143, 133, 93, 83, 23], [142, 82, 22], [121, 81, 21], [120, 20]]

      assert Bridge.Hand.Opening.strong_nt?(hand1)
      assert Bridge.Hand.Opening.strong_nt?(hand2)
    end

    test "it returns false if a hand does not have 15-17 points balanced" do
      hand1 = [[143, 93, 23], [142, 82, 22], [121, 101, 81, 21], [120, 80, 20]]
      hand2 = [[143, 133, 93, 83, 23], [142, 122, 82, 22], [121, 81, 21], [20]]

      refute Bridge.Hand.Opening.strong_nt?(hand1)
      refute Bridge.Hand.Opening.strong_nt?(hand2)
    end
  end

  describe "#five_major?" do
    test "it returns true if hand has a five card major opening" do
      # also balanced 15
      hand1 = [[143, 133, 93, 83, 23], [142, 82, 22], [121, 81, 21], [120, 20]]
      # unbalanced 11 is upgraded
      hand2 = [[133, 93, 83, 23], [142, 122, 92, 82, 22], [121, 81, 21], [20]]
      # 5M5m opens a major
      hand3 = [[143, 133, 93, 83, 23], [142, 82], [21], [120, 90, 80, 70, 20]]

      assert Bridge.Hand.Opening.five_major?(hand1)
      assert Bridge.Hand.Opening.five_major?(hand2)
      assert Bridge.Hand.Opening.five_major?(hand3)
    end

    test "it returns false if hand has another opening or \"should\" pass" do
      # 20 balanced is not 1M opening
      h1 = [[143, 133, 93, 83, 23], [142, 112, 22], [121, 81, 21], [140, 120]]
      # longer minor is not 1M
      h2 = [[143, 133, 93, 83, 23], [142], [21], [120, 110, 90, 80, 70, 20]]
      # balanced 11 is not an opening
      h3 = [[143, 133, 93, 83, 23], [112, 82, 22], [121, 81, 21], [110, 60]]
      # too weak
      h4 = [[143, 133, 93, 83, 23], [112, 72, 22], [81, 71, 21], [50, 40]]

      refute Bridge.Hand.Opening.five_major?(h1)
      refute Bridge.Hand.Opening.five_major?(h2)
      refute Bridge.Hand.Opening.five_major?(h3)
      refute Bridge.Hand.Opening.five_major?(h4)
    end
  end

  describe "#two_nt?" do
    test "it returns true if hand is balanced, 20-21 points," <>
         "5 major possible" do
      h1 = [[143, 133, 93, 83, 23], [142, 112, 22], [121, 81, 21], [140, 120]]
      h2 = [[143, 93, 83, 23], [142, 112, 22], [121, 81, 21], [140, 130, 120]]

      assert Bridge.Hand.Opening.two_nt?(h1)
      assert Bridge.Hand.Opening.two_nt?(h2)
    end

    test "it returns false if hand is not balanced, 20-21" do
      h1 = [[143, 133, 93, 83, 23], [142, 112, 22], [141, 121, 81, 21], [120]]
      h2 = [[143, 93, 83, 23], [142, 112, 22], [121, 81, 21], [130, 120, 30]]

      refute Bridge.Hand.Opening.two_nt?(h1)
      refute Bridge.Hand.Opening.two_nt?(h2)
    end
  end
end
