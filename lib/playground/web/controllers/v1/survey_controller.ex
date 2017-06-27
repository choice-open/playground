defmodule Playground.Web.V1.SurveyController do
  use Playground.Web, :controller

  alias Playground.Psq

  action_fallback Playground.Web.FallbackController

  def show(conn, %{"id" => _}) do
    render conn, "show.json", resp: nil
  end

  def stats(conn, %{"id" => id}) do
    answers = Psq.list_answers(id)
    render conn, "stats.json", answers: answers, id: id
  end

end
