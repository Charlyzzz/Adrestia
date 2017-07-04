defmodule Adrestia.Random do

  def next_server(endpoints) do
    {Enum.random(endpoints), endpoints}
  end
end
