defmodule Playground.Web.AnswerController do
  use Playground.Web, :controller

  alias Playground.PSQ
  alias Playground.PSQ.Answer

  action_fallback Playground.Web.FallbackController

  def create(conn, params) do
    params |> IO.inspect
    with {:ok,  %Answer{}} <- PSQ.create_answer(params) do
      send_resp(conn, :created, "")
    end
  end

end
