defmodule Playground.Repo.Migrations.CreatePlayground.PSQ.Option do
  use Ecto.Migration

  def change do
    create table(:psq_options) do
      add :question_id, :integer
      add :content, :string
      add :count, :integer

      timestamps()
    end

  end
end
