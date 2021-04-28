defmodule Bridge.Suit do
  @moduledoc """
  This module provides many functions that manipulate and calculate things
  related to a single suit isolated.
  It is mostly used as an auxiliary module for the Bridge.Hand module.
  """

  @honours_string %{14 => "A", 13 => "K", 12 => "Q", 11 => "J", 10 => "T"}

  @doc """
  ## (List) -> String
  Receives a hand (list of integers) and returns a string representing the cards
  in that suit (ignoring the suit itself).

  iex> Bridge.Suit.to_s([130, 110, 100, 80, 20])
  "K J T 8 2"

  iex> Bridge.Suit.to_s([])
  "--"
  """
  def to_s([]), do: "--"
  def to_s(suit), do: to_s(suit, "")
  defp to_s([], acc), do: acc
  defp to_s([head | tail], ""),
    do: to_s(tail, "#{get_card_string(head)}")
  defp to_s([head | tail], acc),
    do: to_s(tail, "#{acc} #{get_card_string(head)}")

  defp get_card_string(card) do
    value = div(card, 10)
    @honours_string[value] || value
  end

  @doc """
  ## (List) -> Integer
  Receives a suit (list of integers) and returns how many points are in the suit
  using A = 4, K = 3, Q = 2 and J = 1

  iex> Bridge.Suit.hcp([141, 131, 41])
  7

  iex> Bridge.Suit.hcp([])
  0
  """
  def hcp(suit) do
    suit
    |> Enum.reduce(0, fn (card, acc) ->
      card_value = div(card, 10)
      card_value > 10 && rem(card_value, 10) + acc || acc
    end)
  end
end
