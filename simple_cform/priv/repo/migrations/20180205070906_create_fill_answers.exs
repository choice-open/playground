defmodule SimpleCform.Repo.Migrations.CreateFillAnswers do
  use Ecto.Migration

  def change do
    create table(:fill_answers) do
      add(:content, :text)
      add(:question_id, :integer)

      timestamps()
    end
  end
end
