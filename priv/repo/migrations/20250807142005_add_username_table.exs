defmodule Pento.Repo.Migrations.AddUsernameTable do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :username, :string, null: false, unique: true, default: ""
    end
  end
end
