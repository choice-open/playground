defmodule Playground.V1.ResultController do
  use Playground.Web, :controller

  alias Playground.Answer
  alias Playground.Result
  alias Playground.Question
  alias Playground.Repo
  alias Playground.HelpFunc
  import Ecto.Query

  def index(conn, params) do
    aaa = HelpFunc.start(params["survey_id"])
    |> set_result()
    #json conn, HelpFunc.get_result(params["survey_id"])
    json conn, aaa
    #render conn, "index.json", data: get_result(params["survey_id"])
  end
  
  def show(conn, params) do
    HelpFunc.start(params["survey_id"], params["id"])
    |> set_result()

    json conn, HelpFunc.get_result(params["survey_id"], params["id"])
    #    render conn, "show.json", data: get_result(params["survey_id"], params["id"])
  end

  defp set_result(changes) do
    for change <- changes do
      case Repo.get_by(Result, question_id: change.question_id) do
        nil -> change
          
        result -> 
          new_result = change.result
                        |>cal_new_result(result.result)
          %{question_id: change.question_id, result: new_result, total: result.total + change.total} 
      end
      # |> Result.changeset(changes)
      #|> Repo.insert_or_update!
    end
  end

  defp cal_new_result(change, results) do
    results
    |> Enum.map(fn {k, v} ->
      {k, v + Map.get(change, k)} end)
  end

end
