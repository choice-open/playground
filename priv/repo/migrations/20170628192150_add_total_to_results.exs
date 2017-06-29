defmodule Playground.Repo.Migrations.AddTotalToResults do
  use Ecto.Migration

  def change do
    alter table(:results) do
      add :total, :integer
    end

  end
end
