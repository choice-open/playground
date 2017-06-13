defmodule Playground.Repo.Migrations.CreateAnswer do
  use Ecto.Migration

  def change do
    create table(:answers) do
      add :answer1, {:array, :boolean}
      add :answer1_PHP, :boolean, default: false
      add :answer1_Ruby, :boolean, default: false
      add :answer1_Elixir, :boolean, default: false
      add :answer1_Javascript, :boolean, default: false
      add :answer2, :text
      timestamps
    end
  end
end
