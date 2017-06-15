defmodule Playground.Repo.Migrations.CreatePlayground.PSQ.Question do
  use Ecto.Migration

  def change do
    create table(:psq_questions) do
      add :survey_id, :integer
      add :type, :string
      add :title, :string
      add :required, :boolean, default: true, null: false

      timestamps()
    end

  end
end
