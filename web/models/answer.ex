defmodule Playground.Answer do
  use Playground.Web, :model

  alias Playground.Question
  alias Playground.Repo
  import Ecto.Query

  @derive {Poison.Encoder, except: [:__meta__]}

  schema "answers" do
    field :answers, :map
    field :counted, :boolean, default: false
    field :lock_version, :integer, default: 1
    belongs_to :question, Question
    timestamps()
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:answers, :counted])
    |> validate_required([:answers])
    |> optimistic_lock(:lock_version)
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
        attrs = %{question_id: question.id, answers: answers}
        %{status: :ok, data: attrs}

      _ ->
        %{status: :error, data: "error"}
    end
  end

end

