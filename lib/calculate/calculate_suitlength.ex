defmodule Bridge.Calculate.SuitLength do
  @moduledoc """
  This module implements the questions made to the user in the "Suit Length"
  option, creating the list of checks to be passed to the main Calculate module.
  """

  alias Bridge.Calculate.Helpers
  alias Bridge.{App, Calculate, Hand}

  @suit_function %{
    "Spades" => &Hand.spades/1,
    "Hearts" => &Hand.hearts/1,
    "Diamonds" => &Hand.diamonds/1,
    "Clubs" => &Hand.clubs/1
  }

  def start do
    IO.puts("For each suit, enter the minimum amount of cards, press enter,")
    IO.puts("and then the maximum amount of cards.")

    IO.puts(
      "If no number is typed, it is assumed to be 0 for minimum and " <>
        "13 for maximum."
    )

    IO.puts("For high card points, 40 is the assumed maximum.")
    question1()
  end

  defp question1 do
    ~w[Spades Hearts Diamonds Clubs]
    |> Enum.map(fn suit ->
      {min, max} = Helpers.build_range(suit, :suit)
      {:range, @suit_function[suit], min, max}
    end)
    |> (fn args ->
          (validate_total_suit_length(args) &&
             question2(args)) ||
            App.invalid_option(&question1/0)
        end).()
  end

  defp question2(args) do
    {min, max} = Helpers.build_range("High Card Points\e[0m (hcp)", :hcp)
    finish([{:range, &Hand.hcp/1, min, max} | args])
  end

  defp finish(args) do
    Calculate.get_n(args)
  end

  defp validate_total_suit_length(list) do
    {t_min, t_max} =
      list
      |> Enum.map(fn {:range, _function, min, max} -> {min, max} end)
      |> Enum.reduce({0, 0}, fn {min, max}, {acc1, acc2} ->
        {acc1 + min, acc2 + max}
      end)

    t_min <= 13 && t_max >= 13
  end
end
