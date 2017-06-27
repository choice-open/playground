defmodule Playground.Repo.Migrations.CreatePlayground.Psq.Answer do
  use Ecto.Migration

  def change do
    create table(:psq_answers) do
      add :survey_id, :integer
      timestamps()
    end

  end
end
