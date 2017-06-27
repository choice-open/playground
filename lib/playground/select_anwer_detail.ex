defmodule Playground.SelectAnwerDetail do
  use Ecto.Schema
  import Ecto.Changeset
  alias Playground.SelectAnwerDetail


  schema "select_answer_details" do
    field :content, :string
    field :option_id, :integer
    field :question_id, :integer
    field :question_type, :string
    field :selected, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(%SelectAnwerDetail{} = select_anwer_detail, attrs) do
    select_anwer_detail
    |> cast(attrs, [:question_id, :question_type, :content, :option_id, :selected])
    |> validate_required([:question_id, :question_type, :content, :option_id, :selected])
  end
end
