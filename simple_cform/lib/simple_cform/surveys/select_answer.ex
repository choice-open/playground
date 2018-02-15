defmodule SimpleCform.Surveys.SelectAnswer do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias SimpleCform.Surveys.SelectAnswer

  schema "select_answers" do
    field(:question_id, :integer)
    field(:selected_options, {:array, :integer})

    timestamps()
  end

  @doc false
  def changeset(%SelectAnswer{} = select_answer, attrs) do
    select_answer
    |> cast(attrs, [:selected_options, :question_id])
    |> validate_required([:selected_options, :question_id])
  end

  def count(question_id) do
    from(ans in SelectAnswer, select: count(ans.id), where: ans.question_id == ^question_id)
  end

  def count_option(question_id, option_id) do
    from(
      ans in SelectAnswer,
      select: count(ans.id),
      where: ans.question_id == ^question_id,
      where: ^option_id in ans.selected_options
    )
  end
end
