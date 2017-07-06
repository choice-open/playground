defmodule Playground.Result do
  use Playground.Web, :model

  alias Playground.Question

  @derive {Poison.Encoder, except: [:__meta__]}

  schema "results" do
    field :result, :map
    field :total, :integer
    field :lock_version, :integer, default: 1
    belongs_to :question, Question
    timestamps()
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:result, :total])
    |> optimistic_lock(:lock_version)
    |> validate_required([:result, :total])
    |> assoc_constraint(:question)
  end

end
