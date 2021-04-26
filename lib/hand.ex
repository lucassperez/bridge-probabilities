defmodule Bridge.Hand do
  @honours_string %{14 => "A", 13 => "K", 12 => "Q", 11 => "J", 10 => "T"}
  @suits_string %{0 => "C", 1 => "D", 2 => "H", 3 => "S"}

  @doc """
  () -> List
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
  end

  defp sort_list_of_cards([], hand), do: hand
  defp sort_list_of_cards([head | tail] = _list_of_cards, hand) do
    suit_index = rem(head, 10)
    sort_list_of_cards(
      tail, List.update_at(hand, suit_index, fn suit -> [head  | suit] end)
    )
  end

  @doc """
  (List) -> String
  Receives a hand (list of integers) and return a string representing the hand,
  with each card in each suit.
  It expects the hand to be ordered by suits in this order:
  [ [clubs ], [diamonds], [hearts], [spades] ]
  It will always return the suits in the reverse order as mentioned above.
  Also note that the ten will be represented as a T and a void as --.

  iex> Bridge.Hand.to_s([[70, 60, 30, 20], [111, 101, 91, 81, 31], [], [133, 103, 73, 23]])
  "S: K T 7 2\nH: --\nD: J T 9 8 3\nC: 7 6 3 2"
  """
  def to_s(hand) do
    hand
    |> Enum.with_index
    |> Enum.reverse
    |> Enum.map(fn ({suit, index}) -> {to_s_suit(suit), index} end)
    |> Enum.reduce("", fn ({suit, index}, acc) ->
      "#{acc}\n#{@suits_string[index]}: #{suit}"
    end)
    |> String.trim
  end

  @doc """
  (List) -> String
  Receives a hand (list of integers) and returns a string representing the cards
  in that suit (ignoring the suit itself).

  iex> Bridge.Hand.to_s_suit([130, 110, 100, 80, 20])
  "K J T 8 2"

  iex> Bridge.Hand.to_s_suit([])
  "--"
  """
  def to_s_suit([]), do: "--"
  def to_s_suit(suit), do: to_s_suit(suit, "")
  defp to_s_suit([], acc), do: acc
  defp to_s_suit([head | tail], ""),
    do: to_s_suit(tail, "#{get_card_string(head)}")
  defp to_s_suit([head | tail], acc),
    do: to_s_suit(tail, "#{acc} #{get_card_string(head)}")

  defp get_card_string(card) do
    value = div(card, 10)
    @honours_string[value] || value
  end

  @doc """
  (List) -> String
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
  (List) -> String
  Receives a hand (list) and returns the shape of the hand considering suit
  order, ie, spades, hearts, diamonds and clubs.
  This means that a 4432 necessarily means four spades, four hearts, three
  diamonds and two clubs.

  iex> Bridge.Hand.true_shape([[80, 70, 20], [71, 41, 31, 21], [142, 92, 32, 22], [143, 133]])
  "2443"
  """
  def true_shape(hand) do
    hand
    |> Enum.map(&length &1)
    |> Enum.reverse
    |> Enum.join
  end

  @doc """
  (List) -> Integer
  Receives a hand (four lists of lists of integers) and returns how many points
  are in the whole hand using A = 4, K = 3, Q = 2 and J = 1

  iex> Bridge.Hand.hcp([[143, 93, 23], [122, 102, 92, 82, 32], [141, 31, 21], [110, 80]])
  11
  """
  def hcp(hand) do
    hand
    |> Enum.reduce(0, fn (suit, acc) -> suit_hcp(suit) + acc end)
  end

  @doc """
  (List) -> Integer
  Receives a suit (list of integers) and returns how many points are in the suit
  using A = 4, K = 3, Q = 2 and J = 1

  iex> Bridge.Hand.suit_hcp([141, 131, 41])
  7

  iex> Bridge.Hand.suit_hcp([])
  0
  """
  def suit_hcp(suit) do
    suit
    |> Enum.reduce(0, fn (card, acc) ->
      card_value = div(card, 10)
      card_value > 10 && rem(card_value, 10) + acc || acc
    end)
  end

  @doc """
  (List) -> Integer
  Returns how many spades a hand have, assuming the hand's suits are ordered
  in the following manner:
  [ [clubs ], [diamonds], [hearts], [spades] ]

  iex> Bridge.Hand.spades([[90, 80, 70, 60, 30, 20], [101, 91, 81, 21], [92, 82, 22], []])
  0
  """
  def spades(hand), do: hand |> Enum.at(3) |> length

  @doc """
  (List) -> Integer
  Returns how many hearts a hand have, assuming the hand's suits are ordered
  in the following manner:
  [ [clubs ], [diamonds], [hearts], [spades] ]

  iex> Bridge.Hand.hearts([[90, 80, 70, 60, 30, 20], [101, 91, 81, 21], [92, 82, 22], []])
  3
  """
  def hearts(hand), do: hand |> Enum.at(2) |> length

  @doc """
  (List) -> Integer
  Returns how many diamonds a hand have, assuming the hand's suits are ordered
  in the following manner:
  [ [clubs ], [diamonds], [hearts], [spades] ]

  iex> Bridge.Hand.diamonds([[90, 80, 70, 60, 30, 20], [101, 91, 81, 21], [92, 82, 22], []])
  4
  """

  def diamonds(hand), do: hand |> Enum.at(1) |> length

  @doc """
  (List) -> Integer
  Returns how many clubs a hand have, assuming the hand's suits are ordered
  in the following manner:
  [ [clubs ], [diamonds], [hearts], [spades] ]

  iex> Bridge.Hand.clubs([[90, 80, 70, 60, 30, 20], [101, 91, 81, 21], [92, 82, 22], []])
  6
  """
  def clubs(hand), do: hand |> Enum.at(0) |> length
end
