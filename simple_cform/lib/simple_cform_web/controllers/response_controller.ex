defmodule SimpleCformWeb.ResponseController do
  use SimpleCformWeb, :controller

  def create(conn, _params) do
    conn
    |> put_status(:created)
    |> render("create.json")
  end
end
