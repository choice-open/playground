defmodule SimpleCformWeb.PageController do
  use SimpleCformWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
