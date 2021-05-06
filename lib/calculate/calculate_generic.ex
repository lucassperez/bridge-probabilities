defmodule Bridge.Calculate.Generic do
  @moduledoc """
  This module implements the questions made to the user in the "Generic Options"
  functionality, creating the list of checks to be passed to the main Calculate
  module.
  """

  alias Bridge.{App, Calculate, Hand}

  def start() do
    IO.puts ""
    question()
  end

  defp question do
    IO.gets("\e[1mBalanced?\e[0m [y/n/(i)rrelevant] ")
    |> String.trim
    |> fn input ->
      case String.downcase(input) do
        "y" -> question([{:simple, &Hand.balanced?/1}])
        "n" -> question([{:simple, &Hand.unbalanced?/1}])
        "i" -> question([{:ignore}])
        "" -> question([{:ignore}])
        _ -> App.invalid_option(&question/0)
      end
    end.()
  end

  defp question(args) when length(args) == 1 do
    input = IO.gets("\e[1mAt least how many points\e[0m (hcp)? ")
    hcp = (input == "\n") && 0 || input_to_integer(input)

    if hcp in (0..40) do
      question([{:min, &Hand.hcp/1, hcp} | args])
    else
      IO.puts("\e[93mInvalid amount of hcp\e[0m")
      question(args)
    end
  end

  defp question(args) when length(args) == 2 do
    input = IO.gets("\e[1mAt most how many points\e[0m (hcp)? ")
    hcp = (input == "\n") && 40 || input_to_integer(input)

    minimun_hcp = elem(hd(args), 2)
    if hcp in (minimun_hcp..40) do
      question([{:max, &Hand.hcp/1, hcp} | args])
    else
      IO.puts("\e[93mInvalid amount of hcp\e[0m")
      question(args)
    end
  end

  defp question(args) when length(args) == 3 do
    _n = IO.gets("Select n (defaults to 1000): ")
    |> String.trim
    |> to_integer_or_default
    |> Calculate.calculate(0, 0, args)
  end

  defp to_integer_or_default(s, default \\ 1000) do
    input_to_integer(s) || default
  end

  # FIXME: This function may return either a number or false,
  # is this a good idea?
  defp input_to_integer(s) do
    string = String.trim(s)
    String.match?(string, ~r/^\d+$/) && String.to_integer(string)
  end

end
