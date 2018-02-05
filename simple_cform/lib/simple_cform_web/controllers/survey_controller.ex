defmodule SimpleCformWeb.SurveyController do
  use SimpleCformWeb, :controller
  alias SimpleCform.Surveys

  def show(conn, %{"id" => id}) do
    survey = Surveys.get_survey!(id)
    render(conn, "show.json", survey: survey)
  end
end
