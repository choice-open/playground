defmodule Playground.Repo.Migrations.RenameTableAnswerToAnswers do
  use Ecto.Migration

  def change do
    create table(:answers) do
      add :answers, :map
      add :question_id, references(:questions)
      timestamps()
    end

    drop table(:answer)

  end
end
