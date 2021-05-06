defmodule Bridge.Calculate.Generic do
  @moduledoc """
  This module implements the questions made to the user in the "Generic Options"
  functionality, creating the list of checks to be passed to the main Calculate
  module.
  """

  alias Bridge.{App, Calculate, Hand, Calculate.Helpers}

  def start do
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
    hcp = (input == "\n") && 0 || Helpers.input_to_integer(input)

    if hcp in (0..40) do
      question([{:min, &Hand.hcp/1, hcp} | args])
    else
      IO.puts("\e[93mInvalid amount of hcp\e[0m")
      question(args)
    end
  end

  defp question(args) when length(args) == 2 do
    input = IO.gets("\e[1mAt most how many points\e[0m (hcp)? ")
    hcp = (input == "\n") && 40 || Helpers.input_to_integer(input)

    minimun_hcp = elem(hd(args), 2)
    if hcp in (minimun_hcp..40) do
      finish([{:max, &Hand.hcp/1, hcp} | args])
    else
      IO.puts("\e[93mInvalid amount of hcp\e[0m")
      question(args)
    end
  end

  defp finish(args) do
    Calculate.get_n(args)
  end
end
