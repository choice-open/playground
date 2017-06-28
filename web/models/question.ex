defmodule Playground.Question do
  use Playground.Web, :model

  alias Playground.Survey
  alias Playground.MetaQuestion
  alias Playground.Answer
  alias Playground.Result
  @derive {Poison.Encoder, only: [:position, :meta_quesiton_id]}
  schema "questions" do
    field :position, :integer
    has_many :answers, Answer
    has_one :result, Result
    belongs_to :meta_question, MetaQuestion
    belongs_to :survey, Survey
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:position])
    |> validate_required(:position)
  end

end
