defmodule Playground.MetaQuestion do
  use Playground.Web, :model

  alias Playground.Question

  @derive {Poison.Encoder, except: [:__meta__]}
  schema "meta_questions" do
    field :title, :string
    field :type, :string
    field :required, :boolean, default: false
    field :options, {:array, :string}

    has_many :questions, Question
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:title, :type, :required, :options])
    |> validate_required([:title, :type, :required])
    |> validate_inclusion(:type, ["select", "fill"])
  end

end
