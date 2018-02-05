defmodule SimpleCform.Repo.Migrations.CreateSelectAnswers do
  use Ecto.Migration

  def change do
    create table(:select_answers) do
      add(:selected_options, {:array, :integer})
      add(:question_id, :integer)

      timestamps()
    end
  end
end
