defmodule TestingEcto.Users do
  @moduledoc false

  alias TestingEcto.Repo
  alias TestingEcto.Schemas.User

  def create(params) do
    params
    |> User.create_changeset()
    |> Repo.insert()
  end

  def get(user_id) do
    if user = Repo.get(User, user_id) do
      {:ok, user}
    else
      {:error, :not_found}
    end
  end

  def update(%User{} = existing_user, update_params) do
    existing_user
    |> User.update_changeset(update_params)
    |> Repo.update()
  end

  def delete(%User{} = user) do
    Repo.delete(user)
  end
end
