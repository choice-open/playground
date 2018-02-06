defmodule SimpleCform.Surveys.SelectAnswer do
  use Ecto.Schema
  import Ecto.Changeset
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
end
