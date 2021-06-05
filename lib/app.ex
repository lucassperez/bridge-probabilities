defmodule Bridge.App do
  @moduledoc """
  This module is responsible to start the application and control some of the
  user input and output flow.
  """

  alias Bridge.Calculate.{Generic, SuitLength, PreSet}

  @generic "1"
  @suit_length "2"
  @pre_set "4"
  @exit "0"

  def start do
    IEx.Helpers.clear()
    IO.puts("\t** \e[1mWelcome to my Elixir Application!\e[0m **")
    IO.puts("Here you'll be able to approximate some bridge probabilities")
    IO.puts("by the power of computing a very high number of hands.")
    menu()
  end

  def menu do
    IO.puts("\n\e[0mType a number for each of the following options:")
    IO.puts("\e[32m[#{@generic}] Calculate with generic options")
    IO.puts("\e[32m[#{@suit_length}] Calculate with suit length options")
    IO.puts("\e[32m[#{@pre_set}] Calculate with pre set options")
    IO.puts("\e[93m[#{@exit}] Exit\e[0m\n")
    IO.gets("»» ") |> String.trim() |> menu()
  end

  def menu(@generic), do: Generic.start() && menu()
  def menu(@suit_length), do: SuitLength.start() && menu()
  def menu(@pre_set), do: PreSet.start() && menu()

  def menu(@exit),
    do: IO.puts("\n\e[91;1mThank you for using my app! (:\e[0m\n")

  def menu(_), do: invalid_option(&menu/0)

  def invalid_option(function),
    do: IO.puts("\e[93mInvalid option\e[0m") && function.()

  def invalid_option(function, v1, v2),
    do: IO.puts("\e[93mInvalid option\e[0m") && function.(v1, v2)
end
