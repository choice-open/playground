defmodule Playground.Repo.Migrations.CreateTableResult do
  use Ecto.Migration

  def change do
    create table(:results) do
      add :result, :map
      add :question_id, references(:questions)
      timestamps()
    end

  end
end
