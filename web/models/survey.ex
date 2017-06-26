defmodule Playground.Survey do
  use Playground.Web, :model

  alias Playground.Question

  schema "surveys" do
    field :title, :string
    
    has_many :questions, Question
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, :title)
    |> validate_required(:title)
  end

end
