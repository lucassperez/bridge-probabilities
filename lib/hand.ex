defmodule Bridge.Hand do
  @moduledoc """
  This module provides many functions that manipulate, generate or calculate
  things related to a whole bridge hand, and not the suits separately.
  See Bridge.Suit for comparison.
  """

  alias Bridge.Suit

  @suits_string %{0 => "C", 1 => "D", 2 => "H", 3 => "S"}

  @doc """
  ## () -> List
  Returns a hand, which is a list made of 4 lists of integers representing a
  bridge hand.
  Each card is represented by a number, for instance, 71.
  The first digit of a number is its suit, using the code:
    clubs = 0, diamonds = 1, hearts = 2 and spades = 3
  The rest of the number is its value, using the code:
    14 = Ace, 13 = King, 12 = Queen, 11 = Jack, 10..2 = the number itself
  Which means that 71 is the seven of diamonds, and 143 would be the ace of
  spades and so on.
  """
  def generate_random, do: generate_random([[], [], [], []])

  defp generate_random([[], [], [], []] = hand) do
    _list_of_cards = Enum.take_random(0..51, 13)
    |> Enum.map(fn number ->
      suit = div(number, 13)
      value = rem(number, 13) + 2
      value * 10 + suit
    end)
    |> sort_list_of_cards(hand)
    |> Enum.map(&(Enum.sort(&1, :desc)))
    |> Enum.reverse
  end

  defp sort_list_of_cards([], hand), do: hand
  defp sort_list_of_cards([head | tail] = _list_of_cards, hand) do
    suit_index = rem(head, 10)
    sort_list_of_cards(
      tail, List.update_at(hand, suit_index, fn suit -> [head  | suit] end)
    )
  end

  @doc """
  ## (List) -> String
  Receives a hand (list of integers) and return a string representing the hand,
  with each card in each suit.
  It expects the hand to be ordered by suits in this order:
  [ [clubs ], [diamonds], [hearts], [spades] ]
  It will always return the suits in the reverse order as mentioned above.
  Also note that the ten will be represented as a T and a void as --.

  iex> Bridge.Hand.to_s([[133, 103, 73, 23], [], [111, 101, 91, 81, 31], [70, 60, 30, 20]])
  "S: K T 7 2\nH: --\nD: J T 9 8 3\nC: 7 6 3 2"
  """
  def to_s(hand) do
    hand
    |> Enum.with_index
    |> Enum.map(fn ({suit, index}) -> {Suit.to_s(suit), index} end)
    |> Enum.reduce("", fn ({suit, index}, acc) ->
      "#{acc}\n#{@suits_string[3-index]}: #{suit}"
    end)
    |> String.trim
  end

  @doc """
  ## (List) -> String
  Receives a hand (list) and returns a string with the generic shape of the
  hand, ie, disregarding suit order.
  This means that a 4432 does not necessarily means that the hand has 4 spades,
  4 hearts, 3 diamonds and 2 clubs, it could be any hand with two 4 card suits,
  a tripleton and a doubleton.

  iex> Bridge.Hand.shape([[80, 70, 20], [71, 41, 31, 21], [142, 92, 32, 22], [143, 133]])
  "4432"
  """
  def shape(hand) do
    hand
    |> Enum.map(&length &1)
    |> Enum.sort(:desc)
    |> Enum.join
  end

  @doc """
  ## (List) -> String
  Receives a hand (list) and returns the shape of the hand considering suit
  order, ie, spades, hearts, diamonds and clubs.
  This means that a 4432 necessarily means four spades, four hearts, three
  diamonds and two clubs.

  iex> Bridge.Hand.true_shape([[143, 133], [142, 92, 32, 22], [71, 41, 31, 21], [80, 70, 20]])
  "2443"
  """
  def true_shape(hand) do
    hand
    |> Enum.map(&length &1)
    |> Enum.join
  end

  @doc """
  ## (List) -> Boolean
  Receives a hand (list) and returns true if the hand is balanced, false
  otherwise.
  A hand is considered balanced if it is one of the three possible shapes:
  4333, 4432 and 5332.
  Hands with 5 card major and 5332 pattern are considered balanced.

  iex> Bridge.Hand.balanced?([[143, 133], [142, 92, 32, 22], [71, 41, 31, 21], [80, 70, 20]])
  true

  iex> Bridge.Hand.balanced?([[133, 103, 73, 23], [], [111, 101, 91, 81, 31], [70, 60, 30, 20]])
  false
  """
  def balanced?(hand), do: shape(hand) in ["4333", "4432", "5332"]

  @doc """
  ## (List) -> Integer
  Receives a hand (four lists of lists of integers) and returns how many points
  are in the whole hand using A = 4, K = 3, Q = 2 and J = 1

  iex> Bridge.Hand.hcp([[143, 93, 23], [122, 102, 92, 82, 32], [141, 31, 21], [110, 80]])
  11
  """
  def hcp(hand) do
    hand
    |> Enum.reduce(0, fn (suit, acc) -> Suit.hcp(suit) + acc end)
  end

  @doc """
  ## (List) -> Integer
  Returns how many spades a hand have, assuming the hand's suits are ordered
  in the following manner:
  [ [spades], [hearts], [diamonds], [clubs] ]

  iex> Bridge.Hand.spades([[], [92, 82, 22], [101, 91, 81, 21], [90, 80, 70, 60, 30, 20]])
  0
  """
  def spades(hand), do: hand |> Enum.at(0) |> length

  @doc """
  ## (List) -> Integer
  Returns how many hearts a hand have, assuming the hand's suits are ordered
  in the following manner:
  [ [spades], [hearts], [diamonds], [clubs] ]

  iex> Bridge.Hand.hearts([[], [92, 82, 22], [101, 91, 81, 21], [90, 80, 70, 60, 30, 20]])
  3
  """
  def hearts(hand), do: hand |> Enum.at(1) |> length

  @doc """
  ## (List) -> Integer
  Returns how many diamonds a hand have, assuming the hand's suits are ordered
  in the following manner:
  [ [spades], [hearts], [diamonds], [clubs] ]

  iex> Bridge.Hand.diamonds([[], [92, 82, 22], [101, 91, 81, 21], [90, 80, 70, 60, 30, 20]])
  4
  """
  def diamonds(hand), do: hand |> Enum.at(2) |> length

  @doc """
  ## (List) -> Integer
  Returns how many clubs a hand have, assuming the hand's suits are ordered
  in the following manner:
  [ [spades], [hearts], [diamonds], [clubs] ]

  iex> Bridge.Hand.clubs([[], [92, 82, 22], [101, 91, 81, 21], [90, 80, 70, 60, 30, 20]])
  6
  """
  def clubs(hand), do: hand |> Enum.at(3) |> length
end
