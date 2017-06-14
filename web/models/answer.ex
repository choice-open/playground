defmodule Playground.Answer do
  use Playground.Web, :model

  schema "answers" do
    field :answer1, {:array, :boolean}
    field :answer1_PHP, :boolean, default: false
    field :answer1_Ruby, :boolean, default: false
    field :answer1_Elixir, :boolean, default: false
    field :answer1_Javascript, :boolean, default: false
    field :answer2, :string, default: ""
    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:answer1, :answer2])
    |> validate_required([:answer1])
    |> validate_length(:answer1, is: 4)
    |> divide_answer1()
  end


  defp divide_answer1(changeset) do
    answer = get_field(changeset, :answer1)

    #put_change has no return........
    changeset = put_change(changeset, :answer1_PHP, Enum.at(answer,0))
    changeset = put_change(changeset, :answer1_Ruby, Enum.at(answer,1))
    changeset =  put_change(changeset, :answer1_Elixir, Enum.at(answer,2))
    changeset =  put_change(changeset, :answer1_Javascript, Enum.at(answer,3))
    changeset
  end

    
end

