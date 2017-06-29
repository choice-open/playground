defmodule Playground.V1.SurveyController do
  use Playground.Web, :controller

  @survey (
    Application.app_dir(:playground, "priv/data/survey.json")
    |> File.read!
  )


  def show(conn, _params) do
    json conn, @survey
  end

end
