defmodule Playground.Repo.Migrations.CreateTableAnswer do
  use Ecto.Migration

  def change do
    create table(:answer) do
      add :total_answer, :map
      add :answer, :map
      add :question_id, references(:questions)
      timestamps()

      #add :username, :string
    end

  end
end
