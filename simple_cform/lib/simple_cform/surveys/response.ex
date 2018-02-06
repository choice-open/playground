defmodule SimpleCform.Surveys.Response do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ecto.Multi
  alias SimpleCform.Surveys
  alias SimpleCform.Surveys.Response
  alias SimpleCform.Surveys.SelectAnswer
  alias SimpleCform.Surveys.FillAnswer

  embedded_schema do
    field(:survey_id, :integer)
    field(:answers, {:array, :map})
  end

  def to_multi(changeset) do
    with {_, survey_id} <- changeset |> fetch_field(:survey_id),
         survey <- survey_id |> Surveys.get_survey!(),
         {_, answers_attrs} <- changeset |> fetch_field(:answers) do
      answers_attrs
      |> Enum.reduce(Multi.new(), fn attr, multi ->
        # HACK: support both types of question_id from controller and test
        question_id = attr["question_id"] || attr[:question_id]
        question = get_question(question_id, survey)
        create_answer(multi, question, attr)
      end)
    end
  end

  @doc false
  defp create_answer(multi, %{id: question_id, type: "select", required: true}, attrs) do
    changeset =
      %SelectAnswer{}
      |> SelectAnswer.changeset(attrs)
      |> validate_length(:selected_options, min: 1)

    multi
    |> Multi.insert(question_id, changeset)
  end

  defp create_answer(multi, %{id: question_id, type: "select", required: false}, attrs) do
    changeset =
      %SelectAnswer{}
      |> SelectAnswer.changeset(attrs)

    multi
    |> Multi.insert(question_id, changeset)
  end

  defp create_answer(multi, %{id: question_id, type: "fill", required: true}, attrs) do
    changeset =
      %FillAnswer{}
      |> FillAnswer.changeset(attrs)
      |> validate_required(:content)

    multi
    |> Multi.insert(question_id, changeset)
  end

  defp create_answer(multi, %{id: question_id, type: "fill", required: false}, attrs) do
    changeset =
      %FillAnswer{}
      |> FillAnswer.changeset(attrs)

    multi
    |> Multi.insert(question_id, changeset)
  end

  defp get_question(id, survey) do
    survey.questions
    |> Enum.find(fn question -> question.id == id end)
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
