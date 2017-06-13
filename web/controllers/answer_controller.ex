defmodule Playground.AnswerController do
  use Playground.Web, :controller
  alias Playground.Answer

  def index(conn, _params) do
    json conn, "1:1"
  end

  def create(conn, params) do
    changeset = Answer.changeset(%Answer{}, params)
    case Repo.insert(changeset) do
      {:ok, _} ->
        conn
        |> send_resp(201, "")
      {:error, changeset} ->
        conn
        |> send_resp(400, "")
    end
  end

  def show(conn, params) do
    json conn, "1:1"
  end

  def delete(conn, params) do
    json conn, "1:1"
  end
end

