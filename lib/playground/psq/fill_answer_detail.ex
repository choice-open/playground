defmodule Playground.Psq.FillAnswerDetail do
  use Ecto.Schema
  import Ecto.Changeset
  alias Playground.Psq.FillAnswerDetail


  schema "psq_fill_answer_details" do
    field :content, :string
    field :question_id, :integer
    field :question_type, :string

    belongs_to :answer, Playground.Psq.Answer

    timestamps()
  end

  @doc false
  def changeset(%FillAnswerDetail{} = fill_answer_detail, attrs) do
    fill_answer_detail
    |> cast(attrs, [:question_id, :question_type, :content])
    |> validate_required([:question_id, :question_type])
  end
end
