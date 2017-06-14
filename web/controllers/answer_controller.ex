defmodule Playground.AnswerController do
  use Playground.Web, :controller
  import Ecto.Query
  alias Playground.Answer

  #  plug :scrub_params, "answer2" when action in [:create]

  def index(conn, _params) do
    result = %{php_count: get_php(), php_per: get_percent(get_php(),total_count,2), ruby_count: get_ruby(), ruby_per: get_percent(get_ruby(), total_count,2)}
    total_count = Repo.aggregate(Answer, :count, :id)

  end

  def create(conn, %{"answer1" => a1, "answer2" => a2} = params) do
    changeset = Answer.changeset(%Answer{}, %{"answer1" => a1, "answer2" => String.trim(a2)})
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

  defp get_php() do
    query = from a in "answers", where: a.answer1_PHP == true
    Repo.aggregate(query, :count, :id)
  end
  
  defp get_javascript() do
    query = from a in "answers", where: a.answer1_Javascript == true
    Repo.aggregate(query, :count, :id)
  end

  defp get_ruby() do
    query = from a in "answers", where: a.answer1_Ruby == true
    Repo.aggregate(query, :count, :id)
  end

  defp get_elixir() do
    query = from a in "answers", where: a.answer1_Elixir == true
    Repo.aggregate(query, :count, :id)
  end

  defp get_not_null() do
    query = from a in "answers", where: a.answer2 != ""
    Repo.aggregate(query, :count, :id)
  end

  defp get_percent(left, right, precision) do
    Float.round(left*100/right,precision)
  end

end

