defmodule Playground.Web.QuestionController do
  use Playground.Web, :controller

  alias Playground.PSQ
  alias Playground.PSQ.Question

  action_fallback Playground.Web.FallbackController


  def create(conn, %{"type" => "fill"} = params) do
    with {:ok, %Question{} = question} <- PSQ.create_question(params) do
      conn
      |> put_status(:created)
      |> json(%{id: question.id})
    end
  end

  def create(conn, %{"type" => "select", "options" => _} = params) do
    with {:ok, %Question{} = question} <- PSQ.create_question(params) do
      conn
      |> put_status(:created)
      |> json(%{id: question.id})
    end
  end

  def create(conn, params) do
    with {:ok, %Question{} = question} <- PSQ.create_question(params) do
      conn
      |> put_status(:created)
      |> json(%{id: question.id})
    end
  end

  def delete(conn, %{"id" => id, "survey_id" => survey_id}) do
    question = PSQ.get_question!(id, survey_id)
    with {:ok, %Question{}} <- PSQ.delete_question(question) do
      send_resp(conn, :no_content, "")
    end
  end
end
