defmodule SimpleCform.Surveys.FillAnswer do
  use Ecto.Schema
  import Ecto.Changeset
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
    |> validate_required([:content, :question_id])
  end
end
