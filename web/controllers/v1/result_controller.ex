defmodule Playground.V1.ResultController do
  use Playground.Web, :controller

  alias Playground.HelpFunc

  @doc """
  ## HTTP Verb and URL
  GET /v1/surveys/:survey_id/results

  ### 返回指定问卷的所有答案
  """
  def index(conn, params) do
    calculate(params["survey_id"])
    results = HelpFunc.get_result(params["survey_id"])
    render conn, "index.json", %{data: results, total: get_total_count(params["survey_id"])}
  end
  
  @doc """
  ## HTTP Verb and URL
  GET /v1/surveys/:survey_id/results/:position

  ### 返回指定问卷的指定问题答案，参数为问卷题号
  """
  def show(conn, params) do
    calculate(params["survey_id"], params["id"])
    results = HelpFunc.get_result(params["survey_id"], params["id"])
    render conn, "show.json", %{data: results, total: get_total_count(params["survey_id"])}
  end

  defp calculate(survey) do
    HelpFunc.delete_result(survey)
    HelpFunc.start(survey)
  end

  defp calculate(survey, position) do
    HelpFunc.delete_result(survey, position)
    HelpFunc.start(survey, position)
  end

  defp get_total_count(survey) do
    survey
    |> HelpFunc.get_result_query
    |> Repo.aggregate(:max, :total)
  end

end
