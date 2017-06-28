defmodule Playground.Result do
  use Playground.Web, :model

  alias Playground.Question

  @derive {Poison.Encoder, except: [:__meta__]}

  schema "results" do
    field :result, :map
    field :total, :integer
    belongs_to :question, Question
    timestamps()
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:result, :total])
    |> validate_required([:result, :total])
  end

end
