defmodule Bridge.Calculate.SuitLength do
  @moduledoc """
  This module implements the questions made to the user in the "Suit Length"
  option, creating the list of checks to be passed to the main Calculate module.
  """

  alias Bridge.{App, Calculate, Hand}

  @suit_function %{"Spades" => &Hand.spades/1, "Hearts" => &Hand.hearts/1,
                   "Diamonds" => &Hand.diamonds/1, "Clubs" => &Hand.clubs/1}

  def start() do
    IO.puts("For each suit, enter the minimum amount of cards, press enter,")
    IO.puts("and then the maximum amount of cards.")
    IO.puts("If no number is typed, it is assumed to be 0 for minimum and " <>
      "13 for maximum.")
    IO.puts("For high card points, 40 is the assumed maximum.")
    question()
  end

  defp question do
    ~w[Spades Hearts Diamonds Clubs]
    |> Enum.map(fn suit ->
      {min, max} = build_range(suit, 0, 13)
      {:range, @suit_function[suit], min, max}
    end)
    |> fn args ->
      validate_total_suit_length(args) &&
        question(args) ||
        App.invalid_option(&question/0)
    end.()
  end

  defp question(args) when length(args) == 4 do
    {min, max} = build_range("High Card Points\e[0m (hcp)", 0, 40)
    finish([{:range, &Hand.hcp/1, min, max} | args])
  end

  defp finish(args) do
    Calculate.get_n(args)
  end

  defp build_range(string, low \\ 0, high\\ 40)
  defp build_range(string, low, high) do
    IO.puts("\e[1;34m#{string}\e[0m")
    min = IO.gets("  At least: ")
    |> String.trim
    |> verify_range(low, high, string, :lower)

    max = IO.gets("  At most: ")
    |> String.trim
    |> verify_range(min, high, string, :higher)

    {min, max}
  end

  defp verify_range(input, low \\ 0, high \\ 40, string \\ "", atom \\ :lower)
  defp verify_range("", low, _high, _string, :lower), do: low
  defp verify_range("", _low, high, _string, :higher), do: high
  defp verify_range(input, low, high, string, _atom) do
    int = Calculate.input_to_integer(input)
    int in (low..high) && int || App.invalid_option(&build_range/1, string)
  end

  defp validate_total_suit_length(list) do
    {t_min, t_max} = list
    |> Enum.map(fn {:range, _function, min, max} -> {min, max} end)
    |> Enum.reduce({0, 0}, fn ({min, max}, {acc1, acc2}) ->
      {acc1 + min, acc2 + max}
      end)
    (t_min <= 13 && t_max >= 13)
  end
end
