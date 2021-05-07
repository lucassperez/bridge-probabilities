defmodule Bridge.Calculate.Generic do
  @moduledoc """
  This module implements the questions made to the user in the "Generic Options"
  functionality, creating the list of checks to be passed to the main Calculate
  module.
  """

  alias Bridge.Calculate.Helpers
  alias Bridge.{App, Calculate, Hand}

  def start do
    IO.puts("")
    question1()
  end

  defp question1 do
    IO.gets("\e[1;34mBalanced?\e[0m [y/n/(i)rrelevant]\n  ")
    |> String.trim()
    |> (fn input ->
          case String.downcase(input) do
            "y" -> question2([{:simple, &Hand.balanced?/1}])
            "n" -> question2([{:simple, &Hand.unbalanced?/1}])
            "i" -> question2([{:ignore}])
            "" -> question2([{:ignore}])
            _ -> App.invalid_option(&question1/0)
          end
        end).()
  end

  defp question2(args) do
    {min, max} = Helpers.build_range("High Card Points\e[0m (hcp)", :hcp)
    finish([{:range, &Hand.hcp/1, min, max} | args])
  end

  defp finish(args) do
    Calculate.get_n(args)
  end
end
