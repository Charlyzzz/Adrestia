defmodule Adrestia.RoundRobin do

  def next_server([next_server|rest]) do
    {next_server, rest ++ [next_server]}
  end
end
