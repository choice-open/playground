defmodule Playground.V1.ResultController do
  use Playground.Web, :controller

  alias Playground.{Repo, HelpFunc}

  @doc """
  ## HTTP Verb and URL
  GET /v1/surveys/:survey_id/results

  ### 返回指定问卷的所有答案
  """
  def index(conn, params) do
    results = HelpFunc.get_results(params["survey_id"])
    render conn, "index.json", %{data: results, total: get_total_count(params["survey_id"])}
  end
  
  @doc """
  ## HTTP Verb and URL
  GET /v1/surveys/:survey_id/results/:position

  ### 返回指定问卷的指定问题答案，参数为问卷题号
  """
  def show(conn, params) do
    results = HelpFunc.get_result(params["survey_id"], params["id"])
    render conn, "show.json", %{data: results, total: get_total_count(params["survey_id"])}
  end

  defp get_total_count(survey) do
    survey
    |> HelpFunc.get_result_query
    |> Repo.aggregate(:max, :total)
  end

end
