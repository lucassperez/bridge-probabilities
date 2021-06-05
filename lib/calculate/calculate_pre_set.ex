defmodule Bridge.Calculate.PreSet do
  @moduledoc """
  This module implements the questions made to the user in the "Generic Options"
  functionality, creating the list of checks to be passed to the main Calculate
  module.
  """

  alias Bridge.Calculate

  @options %{
    "1" => "5 card major opening",
    "2" => "Better minor opening",
    "3" => "15-17 balanced (no 5M)",
    "4" => "15-17 balanced (5M possible)",
    "5" => "20-21 balanced (5M possible)",
    "6" => "22+ any"
  }

  def start do
    question1()
  end

  defp question1 do
    IO.puts("Choose which hand type you want:")
    @options
    |> Enum.map(fn {option, message} -> IO.puts("#{option}: #{message}") end)
    |> IO.gets("»» ") |> String.trim() |> make_pre_set_rules()
  end

  defp make_pre_set_rules("1") do
    [
      {:simple, &Hand.five_major?/1},
      {:compare, &Hand.spades/1, &Hand.clubs/1},
      {:compare, &Hand.spades/1, &Hand.diamonds/1},
      {:compare, &Hand.hearts/1, &Hand.clubs/1},
      {:compare, &Hand.hearts/1, &Hand.diamonds/1},
    ]
  end

  defp make_pre_set_rules("2") do
  end

  defp make_pre_set_rules("3") do
  end

  defp make_pre_set_rules("4") do
  end

  defp make_pre_set_rules("5") do
  end

  defp make_pre_set_rules("6") do
  end

  defp finish(args) do
    Calculate.get_n(args)
  end
end
