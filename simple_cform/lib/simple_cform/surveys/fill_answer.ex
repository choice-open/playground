defmodule SimpleCform.Surveys.FillAnswer do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias SimpleCform.Surveys.FillAnswer

  schema "fill_answers" do
    field(:content, :string)
    field(:question_id, :integer)

    timestamps()
  end

  @doc false
  def changeset(%FillAnswer{} = fill_answer, attrs) do
    fill_answer
    |> cast(attrs, [:content, :question_id])
    |> validate_required([:question_id])
  end

  def count(question_id) do
    from(ans in FillAnswer, select: count(ans.id), where: ans.question_id == ^question_id)
  end

  def non_empty_count(question_id) do
    from(
      ans in FillAnswer,
      select: count(ans.id),
      where: ans.question_id == ^question_id,
      where: ans.content != "",
      where: not is_nil(ans.content)
    )
  end
end
