defmodule Playground.Web.SurveyView do
  use Playground.Web, :view
  alias Playground.Web.SurveyView

  def render("index.json", %{surveys: surveys}) do
    render_many(surveys, SurveyView, "survey.json")
  end

  def render("show.json", %{survey: survey}) do
    render_one(survey, SurveyView, "survey.json")
  end

  def render("survey.json", %{survey: survey}) do
    %{
      id: survey.id,
      title: survey.title,
    }
  end

end
