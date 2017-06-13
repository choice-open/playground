defmodule Playground.Repo.Migrations.CreatePlayground.PSQ.Survey do
  use Ecto.Migration

  def change do
    create table(:psq_surveys) do
      add :title, :string

      timestamps()
    end

  end
end
