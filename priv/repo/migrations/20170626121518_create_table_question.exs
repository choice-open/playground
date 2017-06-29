defmodule Playground.Repo.Migrations.CreateTableQuestion do
  use Ecto.Migration

  def change do
    create table(:questions) do
      add :position, :integer
      add :meta_question_id, references(:meta_questions)
      add :survey_id, references(:surveys)
    end

    create index(:questions, [:survey_id, :position])

  end
end
