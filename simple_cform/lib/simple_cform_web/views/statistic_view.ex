defmodule SimpleCformWeb.StatisticView do
  use SimpleCformWeb, :view

  def render("index.json", %{statistics: statistics}) do
    %{
      statistics: statistics
    }
  end
end
