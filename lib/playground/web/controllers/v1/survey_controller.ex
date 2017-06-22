defmodule Playground.Web.V1.SurveyController do
  use Playground.Web, :controller

  def show(conn, %{"id" => _}) do
    render conn, "show.json", resp: nil
  end

end
