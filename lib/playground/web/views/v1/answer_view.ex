defmodule Playground.Web.V1.AnswerView do
  use Playground.Web, :view
  alias Playground.Web.V1.AnswerView

  def render("show.json", %{answer: answer}) do
    render_one(answer, AnswerView, "answer.json")
  end

  def render("answer.json", %{answer: answer}) do
    %{
      id: answer.id,
      survey_id: answer.survey_id,
      fill_question_answer: details(answer.fill_answer_details, :fill),
      select_question_answer: details(answer.select_answer_details, :select),
    }
  end

  def details(fills, :fill) do
    Enum.map fills, fn fill ->
      %{
        question_id: fill.question_id,
        question_type: "fill",
        content: fill.content,
      }
    end
  end

  def details(selects, :select) do
    selects
    |> Enum.group_by(&(&1.question_id))
    |> Enum.map(fn {question_id, answers} ->
      options =
        Enum.map(answers, fn ans ->
          %{
            option_id: ans.option_id,
            content: ans.content,
            selected: ans.selected,
          }
        end)
      %{
        question_id: question_id,
        question_type: "select",
        options: options,
      }
    end)
  end
end
