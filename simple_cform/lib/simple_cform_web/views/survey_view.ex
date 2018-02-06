defmodule SimpleCformWeb.SurveyView do
  use SimpleCformWeb, :view

  def render("show.json", %{survey: survey}) do
    survey
  end
end
