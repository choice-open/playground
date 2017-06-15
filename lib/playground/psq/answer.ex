defmodule Playground.PSQ.Answer do
  use Ecto.Schema
  import Ecto.Changeset
  alias Playground.PSQ.Answer


  schema "psq_answers" do
    field :content, :string
    field :question_id, :integer
    field :survey_id, :integer, virtual: true

    timestamps()
  end

  @doc false
  def changeset(%Answer{} = answer, attrs) do
    answer
    |> cast(attrs, [:question_id, :content, :survey_id])
    |> validate_required([:question_id, :survey_id])
  end
end
