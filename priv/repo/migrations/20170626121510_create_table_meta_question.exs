defmodule Playground.Repo.Migrations.CreateTableMetaQuestion do
  use Ecto.Migration

  def change do
    create table(:meta_questions) do
      add :title, :string
      add :type, :string
      add :required, :boolean
      add :options, {:array, :string}
    end

  end
end
