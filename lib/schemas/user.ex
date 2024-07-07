defmodule TestingEcto.Schemas.User do
  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts type: :utc_datetime_usec
  @primary_key {:id, :binary_id, autogenerate: true}

  @optional_create_fields [:id, :favorite_number, :inserted_at, :updated_at]
  @forbidden_update_fields [:id, :inserted_at, :updated_at]

  schema "users" do
    field(:date_of_birth, :date)
    field(:email, :string)
    field(:favorite_number, :float)
    field(:first_name, :string)
    field(:last_name, :string)
    field(:phone_number, :string)

    timestamps()
  end

  defp all_fields do
    __MODULE__.__schema__(:fields)
  end

  def create_changeset(params) do
    %__MODULE__{}
    |> cast(params, all_fields())
    |> validate_required(all_fields() -- @optional_create_fields)
    |> unique_constraint(:email)
  end

  def update_changeset(%__MODULE__{} = user, params) do
    user
    |> cast(params, all_fields() -- @forbidden_update_fields)
    |> unique_constraint(:email)
  end
end
