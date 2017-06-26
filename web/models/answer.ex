defmodule Playground.Answer do
  use Playground.Web, :model

  alias Playground.Question

  schema "answers" do
    field :total_answer, :map, virtual: true
    field :answers, :map
    field :position, :integer, virtual: true
    belongs_to :question, Question
    timestamps()
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:total_answer, :answers, :position])
  end

  def devide_to_insert(params) do
  end

end

