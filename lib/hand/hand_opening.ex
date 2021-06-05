defmodule Bridge.Hand.Opening do
  alias Bridge.Hand

  @doc """
  ## (List) -> Boolean
  Returns true if a hand is balanced and has 15 to 17 points, 5 card major
  possible, false otherwise.

  iex> Bridge.Hand.Opening.strong_nt?([[143, 93, 23], [122, 102, 92, 82, 32], [141, 31, 21], [110, 80]])
  false
  """
  def strong_nt?(hand) do
    Hand.balanced?(hand) &&
      Hand.hcp(hand) in 15..17
  end

  @doc """
  ## (List) -> Boolean
  Returns true if a hand has a five card major opening, false otherwise.
  20+ balanced is not a five card major opening, but 15-17 is.

  iex> Bridge.Hand.Opening.five_major?([[143, 133, 93, 83, 23], [142, 82, 22], [101, 81, 21], [120, 20]])
  true
  """
  def five_major?(hand) do
    [s, h, d, c] = Hand.true_shape(hand) |> String.split("", trim: true)
    hcp = Hand.hcp(hand)

    !two_nt?(hand, hcp) && opening_points(hand) && (
      (s >= 5 && s >= h && s >= d && s >= c) ||
      (h >= 5 && h > s && h >= d && h >= c)
    )
  end

  @doc """
  ## (List) -> Boolean
  Returns true if a hand is balanced with 20 or 21 points, possible 5 card
  majors, false otherwise.

  iex> Bridge.Hand.Opening.two_nt?([[143, 133, 93, 83, 23], [142, 112, 22], [121, 81, 21], [140, 120]])
  true
  """
  def two_nt?(hand), do: two_nt?(hand, Hand.hcp(hand))
  defp two_nt?(hand, hcp), do: Hand.balanced?(hand) && hcp in 20..21

  defp opening_points(hand) do
    hcp = Hand.hcp(hand)
    hcp in 12..21 || (hcp == 11 && Hand.unbalanced?(hand))
  end
end
