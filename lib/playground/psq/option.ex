defmodule Playground.PSQ.Option do
  use Ecto.Schema
  import Ecto.Changeset
  alias Playground.PSQ.Option


  schema "psq_options" do
    field :content, :string
    field :count, :integer
    field :question_id, :integer

    timestamps()
  end

  @doc false
  def changeset(%Option{} = option, attrs) do
    option
    |> cast(attrs, [:question_id, :content, :count])
    |> validate_required([:question_id, :content, :count])
  end
end
