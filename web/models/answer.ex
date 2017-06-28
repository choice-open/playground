defmodule Playground.Answer do
  use Playground.Web, :model

  alias Playground.Question
  alias Playground.Repo
  import Ecto.Query

  schema "answers" do
    field :answers, :map
    belongs_to :question, Question
    timestamps()
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:answers])
    |> validate_required([:answers])
  end

  def serialize_params(%{"position" => position, "answers" => answer}, survey_id) do

    survey_id
    |> get_query()
    |> Repo.get_by!(position: position)
    |> format_answers(answer)
  end

  defp get_query(survey_id) do
    from q in Question,
      join: m in assoc(q, :meta_question),
      where: q.survey_id == ^survey_id,
      preload: [meta_question: m]
  end

  def format_answers(question, answers) do
    case String.to_atom(question.meta_question.type) do
      :fill ->
        answer = %{answers: String.trim(answers)}
        attrs = %{question_id: question.id, answers: answer}
        %{status: :ok, data: attrs}
      
      :select ->
        answer = Enum.zip(question.meta_question.options, answers)
                 |> Enum.into(%{})
        attrs = %{question_id: question.id, answers: answer}
        %{status: :ok, data: attrs}

      _ ->
        %{status: :error, data: "error"}
    end
  end

end

