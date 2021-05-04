defmodule Bridge.Calculate.Options do
  @moduledoc """
  This module should implement the functions that "calculate" some probability
  based on options provided by the user.
  It should be triggered by the Bridge.App module.
  """

  alias Bridge.{App, Hand}

  def start do
    question()
  end

  defp question do
    IO.gets("\n\e[1mBalanced?\e[0m [y/n/(i)rrelevant] ")
    |> String.trim
    |> fn input ->
      case String.downcase(input) do
        "y" -> question([&Hand.balanced?/1])
        "n" -> question([&Hand.unbalanced?/1])
        "i" -> question([fn _ -> true end])
        "" -> question([fn _ -> true end])
        _ -> App.invalid_option(&question/0)
      end
    end.()
  end

  defp question(args) when length(args) == 1 do
    input = IO.gets("\e[1mAt least how many points (hcp)?\e[0m ")
    hcp = (input == "\n") && 0 || input_to_integer(input)

    if hcp in (0..40) do
      question([{&Hand.greater_than_or_equal_to_hcp/2, hcp} | args])
    else
      IO.puts("\e[93mInvalid amount of hcp\e[0m")
      question(args)
    end
  end

  defp question(args) when length(args) == 2 do
    input = IO.gets("\e[1mAt most how many points\e[0m (hcp)? ")
    hcp = (input == "\n") && 40 || input_to_integer(input)

    minimun_hcp = elem(hd(args), 1)
    if hcp in (minimun_hcp..40) do
      question([{&Hand.less_than_or_equal_to_hcp/2, hcp} | args])
    else
      IO.puts("\e[93mInvalid amount of hcp\e[0m")
      question(args)
    end
  end

  defp question(args) when length(args) == 3 do
    _n = IO.gets("Select n (defaults to 1000): ")
    |> String.trim
    |> to_integer_or_default
    |> calculate(0, 0, args, Hand.generate_random())
  end

  defp to_integer_or_default(s, default \\ 1000) do
    input_to_integer(s) || default
  end

  defp calculate(n, verified, total, _args, _hand) when n == verified do
    percentage = verified / total * 100 |> Float.round(3)
    IO.puts "\e[1;32mFinal results:\e[0m"
    IO.puts "#{verified} out of #{total} (\e[1m#{percentage}%\e[0m)"
    IO.gets("\n\e[4mPress any key to return to main menu...\e[3m")
  end

  defp calculate(n, verified, total, args, hand) do
    _hand_verifies = args
    |> Enum.reduce(true, fn (action, acc) ->
      acc && case action do
        {func, value} -> func.(hand, value)
        func -> func.(hand)
      end
    end) &&
      calculate(n, verified + 1, total + 1, args, Hand.generate_random()) ||
      calculate(n, verified, total + 1, args, Hand.generate_random())
  end

  # FIXME: This function may return either a number or nil, is this a good idea?
  defp input_to_integer(s) do
    string = String.trim(s)
    String.match?(string, ~r/^\d+$/) && String.to_integer(string) || nil
  end
end
