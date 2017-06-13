defmodule Playground.PSQ.Survey do
  use Ecto.Schema
  import Ecto.Changeset
  alias Playground.PSQ.Survey


  schema "psq_surveys" do
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(%Survey{} = survey, attrs) do
    survey
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
