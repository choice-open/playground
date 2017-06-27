defmodule Playground.Repo.Migrations.CreatePlayground.Psq.SelectAnswerDetail do
  use Ecto.Migration

  def change do
    create table(:psq_select_answer_details) do
      add :question_id, :integer
      add :answer_id, references(:psq_answers)
      add :question_type, :string
      add :content, :string
      add :option_id, :integer
      add :selected, :boolean, default: false, null: false

      timestamps()
    end

  end
end
