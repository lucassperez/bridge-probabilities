defmodule Bridge.Calculate.Helpers do
  @moduledoc """
  Module with helper functions used by other sub modules of Bridge.Calculate
  """

  alias Bridge.App

  # FIXME: This function may return either a number or false,
  # is this a good idea?
  def input_to_integer(s) do
    String.trim(s)
    |> fn string ->
      String.match?(string, ~r/^\d+$/) && String.to_integer(string)
    end.()
  end

  def build_range(message, :hcp), do: build_range(message, 0, 40, :hcp)
  def build_range(message, :suit), do: build_range(message, 0, 13, :suit)
  def build_range(message, low, high, type) do
    IO.puts("\e[1;34m#{message}\e[0m")
    min = IO.gets("  At least: ")
    |> String.trim
    |> fn input ->
      case String.downcase(input) do
        "" -> low
        _ -> input_to_integer(input)
      end
    end.()

    max = IO.gets("  At most: ")
    |> String.trim
    |> fn input ->
      case String.downcase(input) do
        "" -> high
        _ -> input_to_integer(input)
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
end
