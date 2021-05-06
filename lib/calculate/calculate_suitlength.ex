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
      {min, max} = build_range(suit, :suit)
      {:range, @suit_function[suit], min, max}
    end)
    |> fn args ->
      validate_total_suit_length(args) &&
        question(args) ||
        App.invalid_option(&question/0)
    end.()
  end

  defp question(args) when length(args) == 4 do
    {min, max} = build_range("High Card Points\e[0m (hcp)", :hcp)
    finish([{:range, &Hand.hcp/1, min, max} | args])
  end

  defp finish(args) do
    Calculate.get_n(args)
  end

  defp build_range(message, :hcp), do: build_range(message, 0, 40, :hcp)
  defp build_range(message, :suit), do: build_range(message, 0, 13, :suit)
  defp build_range(message, low, high, type) do
    IO.puts("\e[1;34m#{message}\e[0m")
    min = IO.gets("  At least: ")
    |> String.trim
    |> fn input ->
      case String.downcase(input) do
        "" -> low
        _ -> Calculate.input_to_integer(input)
      end
    end.()

    max = IO.gets("  At most: ")
    |> String.trim
    |> fn input ->
      case String.downcase(input) do
        "" -> high
        _ -> Calculate.input_to_integer(input)
      end
    end.()

    if validate_range(min, max, low, high) do
      {min, max}
    else
      App.invalid_option(&build_range/2, message, type)
    end
  end

  defp validate_range(min, max, low_limit, high_limit) do
    min <= max &&
      min in (low_limit..high_limit) &&
      max in (low_limit..high_limit)
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
