defmodule Playground.V1.AnswerController do
  use Playground.Web, :controller

  alias Playground.Answer

  def create(conn, params) do
    answers = for a <- params["_json"] do
      a
      |> Answer.serialize_params(params["survey_id"])
    end

    #如果存在转换失败，报错
    if is_nil(Keyword.get(answers, :error)) == false do
      conn
      |> send_resp(400, "")

    else
      aaa = answers
      |> Keyword.get_values(:ok)

      json conn, aaa
      #      insert_result = for ans <- aaa do
      #  Answer.changeset(%Answer{}, ans.answers)
      #  |> Ecto.Changeset.put_assoc(:question, ans.question)
      #  |> Repo.insert!()
      #end
      # 
      #if is_nil(Keyword.get(insert_result, :error)) do
      #  conn
      #  |> send_resp(201, "")
      #
      #else 
      #  conn
      #  |> send_resp(400, "")
      #end

    end

  end


end
