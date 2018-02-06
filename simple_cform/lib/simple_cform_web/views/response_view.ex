defmodule SimpleCformWeb.ResponseView do
  use SimpleCformWeb, :view

  alias SimpleCform.Surveys.SelectAnswer
  alias SimpleCform.Surveys.FillAnswer

  def render("create.json", %{response: response}) do
    %{
      response: %{
        survey_id: response.survey_id,
        answers:
          for answer <- response.answers do
            answer |> to_json()
          end
      }
    }
  end

  defp to_json(%SelectAnswer{} = select_answer) do
    %{
      question_id: select_answer.question_id,
      selected_options: select_answer.selected_options
    }
  end

  defp to_json(%FillAnswer{} = fill_answer) do
    %{
      question_id: fill_answer.question_id,
      content: fill_answer.content
    }
  end
end
