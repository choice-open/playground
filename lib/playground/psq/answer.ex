defmodule Playground.Psq.Answer do
  use Ecto.Schema
  import Ecto.Changeset
  alias Playground.Psq.Answer


  schema "psq_answers" do
    field :survey_id, :integer

    has_many :fill_answer_details, Playground.Psq.FillAnswerDetail
    has_many :select_answer_details, Playground.Psq.SelectAnswerDetail

    timestamps()
  end

  @doc false
  def changeset(%Answer{} = answer, attrs) do
    answer
    |> cast(attrs, [:survey_id])
    |> validate_required([:survey_id])
  end
end
