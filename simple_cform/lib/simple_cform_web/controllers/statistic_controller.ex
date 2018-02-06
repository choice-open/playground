defmodule SimpleCformWeb.StatisticController do
  use SimpleCformWeb, :controller

  alias SimpleCform.Surveys

  def index(conn, %{"survey_id" => survey_id}) do
    statistics =
      survey_id
      |> String.to_integer()
      |> Surveys.get_statistics()

    conn
    |> render("index.json", statistics: statistics)
  end
end
