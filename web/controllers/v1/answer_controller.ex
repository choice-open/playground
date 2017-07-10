defmodule Playground.V1.AnswerController do
  use Playground.Web, :controller

  alias Playground.{Answer, HelpFunc}

  @results []
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
      results = Enum.reduce(answers, [], fn(x, acc) -> acc ++ [%{question_id: x.data.question_id, answers: x.data.answers}] end)

      insert_status = Repo.transaction(fn ->
        for res <- results do
          Repo.insert!(struct(Answer, res))
        end
      end)
      case insert_status do
        {:ok, _} ->
          #Calculate results
          case HelpFunc.start(params["survey_id"]) do
            {:ok, _} ->
              conn
              |> send_resp(201,"")
            {_, _} ->
              conn
              |> send_resp(400, "")
          end
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
