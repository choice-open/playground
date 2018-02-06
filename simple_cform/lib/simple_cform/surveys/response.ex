defmodule SimpleCform.Surveys.Response do
  use Ecto.Schema
  import Ecto.Changeset
  alias SimpleCform.Surveys
  alias SimpleCform.Surveys.Response

  embedded_schema do
    field(:survey_id, :integer)
    field(:answers, {:array, :map})
  end

  def changeset(%Response{} = response, attrs) do
    response
    |> cast(attrs, [:survey_id, :answers])
    |> validate_required([:survey_id, :answers])
    |> validate_all_questions_were_answered()
  end

  defp validate_all_questions_were_answered(changeset) do
    with {_, survey_id} <- changeset |> fetch_field(:survey_id),
         survey <- survey_id |> Surveys.get_survey!() do
      changeset
      |> validate_change(:answers, fn :answers, answers ->
        asked_questions_ids = survey.questions |> Enum.map(& &1.id) |> Enum.sort()

        answered_questions_ids =
          answers |> Enum.map(&(&1[:question_id] || &1["question_id"])) |> Enum.sort()

        unanswered_questions_ids =
          asked_questions_ids
          |> Enum.filter(&(&1 not in answered_questions_ids))

        if Enum.empty?(unanswered_questions_ids) do
          []
        else
          [
            answers:
              {"some questions were not answered",
               [unanswered_questions_ids: unanswered_questions_ids]}
          ]
        end
      end)
    end
  end
end
