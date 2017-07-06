defmodule Playground.Repo.Migrations.AddLockToResults do
  use Ecto.Migration

  def change do
    alter table(:results) do
      add :lock_version, :integer, default: 1
    end

  end
end
