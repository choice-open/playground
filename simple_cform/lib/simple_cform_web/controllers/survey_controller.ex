defmodule SimpleCformWeb.SurveyController do
  use SimpleCformWeb, :controller

  def show(conn, _params) do
    render(conn, "show.json")
  end
end
