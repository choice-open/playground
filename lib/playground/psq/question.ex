defmodule Playground.PSQ.Question do
  use Ecto.Schema
  import Ecto.Changeset
  alias Playground.PSQ.Question


  schema "psq_questions" do
    field :required, :boolean, default: true
    field :survey_id, :integer
    field :title, :string
    field :type, :string
    field :options, {:array, :string}, virtual: true

    timestamps()
  end

  @doc false
  def changeset(%Question{} = question, attrs) do
    question
    |> cast(attrs, [:survey_id, :type, :title, :required, :options])
    |> validate_required([:survey_id, :type, :title, :required])
  end
end
