defmodule Playground.V1.ResultController do
  use Playground.Web, :controller

  alias Playground.Answer
  alias Playground.Result
  alias Playground.Question
  alias Playground.Repo
  alias Playground.HelpFunc
  import Ecto.Query

  def index(conn, params) do
    calculate(params["survey_id"])
    results = HelpFunc.get_result(params["survey_id"])
    render conn, "index.json", data: results
  end
  
  def show(conn, params) do
    calculate(params["survey_id"], params["id"])
    results = HelpFunc.get_result(params["survey_id"], params["id"])
    render conn, "show.json", data: results
  end

  defp calculate(survey) do
    HelpFunc.delete_result(survey)
    HelpFunc.start(survey)
  end

  defp calculate(survey, position) do
    HelpFunc.delete_result(survey, position)
    HelpFunc.start(survey, position)
  end

end
