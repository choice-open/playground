defmodule SimpleCformWeb.ResponseController do
  use SimpleCformWeb, :controller

  alias SimpleCform.Surveys

  def create(conn, params) do
    with {:ok, response} <- Surveys.create_response(params) do
      conn
      |> put_status(:created)
      |> render("create.json", response: response)
    else
      {:error, [answers: {_, [unanswered_questions_ids: unanswered_questions_ids]}]} ->
        conn
        |> put_status(:bad_request)
        |> render("error.json", unanswered_questions_ids: unanswered_questions_ids)

      {:error, failed_question_id, failed_answer} ->
        conn
        |> put_status(:bad_request)
        |> render(
          "error.json",
          failed_question_id: failed_question_id,
          failed_answer: failed_answer
        )
    end
  end
end
