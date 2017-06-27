defmodule Playground.Web.V1.AnswerController do
  use Playground.Web, :controller

  alias Playground.Psq
  alias Playground.Psq.Answer

  action_fallback Playground.Web.FallbackController

  def create(conn, params = %{"survey_id" => _survey_id, "answers" => _answer_params}) do
    with {:ok, %Answer{}} <- Psq.create_answer(params) do
      conn
      |> put_status(:created)
      |> json(:ok)
    end
  end

  def show(conn, %{"survey_id" => survey_id, "id" => id}) do
    answer = Psq.get_answer!(survey_id, id)
    render(conn, "show.json", answer: answer)
  end


end
