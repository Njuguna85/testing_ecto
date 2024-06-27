defmodule TestingEcto.Schemas.UserDatabaseSchema do
  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts type: :utc_datetime_usec
  @primary_key {:id, :binary_id, autogenerate: true}
  @optional_fields [:id, :favorite_number]

  schema "users" do
    field(:date_of_birth, :date)
    field(:email, :string)
    field(:favorite_number, :float)
    field(:first_name, :string)
    field(:last_name, :string)
    field(:phone_number, :string)

    timestamps()
  end

  # it will always return an up to date list of fields as atoms e
  # even when a new field is added
  defp all_fields do
    __MODULE__.__schema__(:fields)
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, all_fields())
    |> validate_required(all_fields() -- @optional_fields)
    |> unique_constraint(:email)
  end
end
