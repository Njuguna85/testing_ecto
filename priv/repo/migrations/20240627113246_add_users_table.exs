defmodule TestingEcto.Repo.Migrations.AddUsersTable do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:date_of_birth, :date, null: false)
      add(:email, :string, null: false)
      add(:favorite_number, :float)
      add(:first_name, :string, null: false)
      add(:last_name, :string, null: false)
      add(:phone_number, :string, null: false)

      timestamps()
    end

    create(unique_index(:users, [:email]))
  end
end
