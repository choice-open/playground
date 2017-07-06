defmodule Playground.V1.AnswerController do
  use Playground.Web, :controller

  alias Playground.Answer

  @doc """
  ## HTTP Verb and URL
    POST /v1/surveys/:survey_id/answers

  ## Params
  [{"position": x, answers: "String"}, {"position": x, answers: [boolean list], ... ]
  """
  def create(conn, params) do
    answers = for a <- params["_json"] do
      a
      |> Answer.serialize_params(params["survey_id"])
    end

    #如果存在转换失败，返回400
    if check_list(answers) == :error do
      conn
      |> send_resp(400, "")
    else
      insert_status = Repo.transaction(fn ->
        for ans <- answers do
          Repo.insert!(%Answer{question_id: ans.data.question_id, answers: ans.data.answers})
        end
      end)
      case insert_status do
        {:ok, _} ->
          conn
        |> send_resp(201,"")
        {_, _} ->
          conn
          |> send_resp(400, "")
      end
    end

  end

  defp check_list([]) do
    :ok
  end

  defp check_list([head | tail]) do
    if head.status == :ok do
      check_list(tail)
    else
      :error
    end
  end

end
