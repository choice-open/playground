defmodule Playground.Repo.Migrations.CreatePlayground.Psq.FillAnswerDetail do
  use Ecto.Migration

  def change do
    create table(:psq_fill_answer_details) do
      add :question_id, :integer
      add :answer_id, references(:psq_answers)
      add :question_type, :string
      add :content, :string

      timestamps()
    end

  end
end
