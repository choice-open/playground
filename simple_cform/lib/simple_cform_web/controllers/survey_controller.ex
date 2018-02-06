defmodule SimpleCformWeb.SurveyController do
  use SimpleCformWeb, :controller
  alias SimpleCform.Surveys

  def show(conn, %{"id" => id}) do
    survey =
      id
      |> String.to_integer()
      |> Surveys.get_survey!()

    render(conn, "show.json", survey: survey)
  end
end
