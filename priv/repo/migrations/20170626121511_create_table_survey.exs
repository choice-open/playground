defmodule Playground.Repo.Migrations.CreateTableSurvey do
  use Ecto.Migration

  def change do
    create table(:surveys) do
      add :title, :string
    end

  end
end
