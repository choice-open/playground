defmodule Playground.Repo.Migrations.AddLockToAnswers do
  use Ecto.Migration

  def change do
    alter table(:answers) do
      add :counted, :boolean, default: false
      add :lock_version, :integer, default: 1
    end

  end
end
