defmodule Playground.SurveyController do
  use Playground.Web, :controller

  @survey (
    Application.app_dir(:playground, "priv/data/survey.json")
    |> File.read!
  )

  def index(conn, _params) do
    conn
    |> send_resp(200, "")
  end

  def show(conn, params) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, @survey)
  end
  
end
