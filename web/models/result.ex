defmodule Playground.Result do
  use Playground.Web, :model

  alias Playground.Question

  schema "results" do
    field :result, :map
    belongs_to :question, Question
    timestamps()
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:result])
    |> validate_required(:result)
  end

end
