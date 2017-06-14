defmodule Playground.Repo.Migrations.CreatePlayground.PSQ.Answer do
  use Ecto.Migration

  def change do
    create table(:psq_answers) do
      add :question_id, :integer
      add :content, :string

      timestamps()
    end

  end
end
