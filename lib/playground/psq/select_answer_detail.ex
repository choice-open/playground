defmodule Playground.Psq.SelectAnswerDetail do
  use Ecto.Schema
  import Ecto.Changeset
  alias Playground.Psq.SelectAnswerDetail


  schema "psq_select_answer_details" do
    field :question_id, :integer
    field :question_type, :string
    field :option_id, :integer
    field :content, :string
    field :selected, :boolean

    belongs_to :answer, Playground.Psq.Answer

    timestamps()
  end

  @doc false
  def changeset(%SelectAnswerDetail{} = select_answer_detail, attrs) do
    select_answer_detail
    |> cast(attrs, [:question_id, :question_type, :content])
    |> validate_required([:question_id, :question_type])
  end
end
