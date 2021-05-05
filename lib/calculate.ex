defmodule Bridge.Calculate do
  @moduledoc """
  This module is responsible to generate hands until certain conditions are met.
  The main function calculate/5 should be generic enough to receive
  specifications as arguments and don't depend on the specifications'
  implementation itself.
  """

  alias Bridge.Hand

  def calculate(n, verified, total, _args, last_hand \\ [])

  def calculate(n, verified, total, _args, last_hand) when n == verified do
    percent = percentage(verified, total)
    IO.puts "\e[1;32mFinal results:\e[0m"
    IO.puts "#{verified} out of #{total} (\e[1m#{percent}%\e[0m)"
    !Enum.empty?(last_hand) &&
      IO.puts "Last generated hand:\n#{Hand.to_s(last_hand)}"
  end

  def calculate(n, verified, total, args, _last_hand) do
    hand = Hand.generate_random()
    verify_hand(args, hand) &&
      calculate(n, verified + 1, total + 1, args, hand) ||
      calculate(n, verified, total + 1, args, hand)
  end

  defp verify_hand(args, hand) do
    args
    |> Enum.reduce(true, fn (action, acc) ->
      acc and case action do
        {:min, func, value} -> func.(hand) >= value
        {:max, func, value} -> func.(hand) <= value
        {:simple, func} -> func.(hand)
        {:ignore} -> true
      end
    end)
  end

  defp percentage(verified, total) when verified == 0 or total == 0, do: 0
  defp percentage(verified, total), do: verified / total * 100 |> Float.round(3)
end
