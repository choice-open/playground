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

  def render("error.json", %{failed_question_id: failed_question_id, failed_answer: failed_answer}) do
    %{
      error: %{
        failed_question_id: failed_question_id,
        reason:
          for {field, error} <- failed_answer.errors, into: %{} do
            {field, translate_error(error)}
          end
      }
    }
  end

  def render("error.json", %{unanswered_questions_ids: unanswered_questions_ids}) do
    %{
      error: %{
        unanswered_questions_ids: unanswered_questions_ids,
        reason: %{answers: "Some questions were not answered."}
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
