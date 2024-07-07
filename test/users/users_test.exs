defmodule TestingEcto.UsersTest do
  use TestingEcto.DataCase
  alias TestingEcto.Users
  alias TestingEcto.Schemas.User

  # every test will require a database connection
  setup do
    Ecto.Adapters.SQL.Sandbox.checkout(TestingEcto.Repo)
  end

  describe "create/1" do
    test "success: it inserts a user in the db and returns the user" do
      # this will call user_factory/0 in our factory
      # even though our function user_factory returns a User schema,
      # ExMachina will take the return value and convert it to a string-keyed
      # map in order to provide string_params
      params = Factory.string_params_for(:user)
      now = DateTime.utc_now()

      assert {:ok, %User{} = returned_user} = Users.create(params)

      user_from_db = Repo.get(User, returned_user.id)
      assert returned_user == user_from_db

      mutated = ["date_of_birth"]

      # this list comprehension checks that all the values that we are
      # expecting and check that the same value is present in the database
      # ie the returned User schema
      for {param_field, expected} <- params, param_field not in mutated do
        schema_field = String.to_existing_atom(param_field)
        actual = Map.get(user_from_db, schema_field)

        assert actual == expected,
               "Values did not match for field: #{param_field}\n expected: #{inspect(expected)}\n actual: #{inspect(actual)}"
      end

      expected_dob = Date.from_iso8601!(params["date_of_birth"])
      assert user_from_db.date_of_birth == expected_dob

      assert user_from_db.inserted_at == user_from_db.updated_at
      assert DateTime.compare(now, user_from_db.inserted_at) == :lt
    end

    test "error: returns an error tuple when user can't be created" do
      missing_params = %{}

      assert {:error, %Changeset{valid?: false}} = Users.create(missing_params)
    end
  end

  describe "get/1" do
    test "success: it returns a user when given a valid UUID" do
      existing_user = Factory.insert(:user)

      assert {:ok, returned_user} = Users.get(existing_user.id)

      assert returned_user == existing_user
    end

    test "error: it returns an error tuple when a user doesn't exist " do
      assert {:error, :not_found} = Users.get(Ecto.UUID.generate())
    end
  end

  describe "update/2" do
    test "success: it updates database and returns the user" do
      existing_user = Factory.insert(:user)

      params =
        Factory.string_params_for(:user)
        |> Map.take(["first_name"])

      assert {:ok, returned_user} = Users.update(existing_user, params)

      user_from_db = Repo.get(User, returned_user.id)
      assert returned_user == user_from_db

      expected_user_data =
        existing_user
        |> Map.from_struct()
        |> Map.drop([:__meta__, :updated_at])
        |> Map.merge(%{first_name: params["first_name"]})

      for {field, expected} <- expected_user_data do
        actual = Map.get(user_from_db, field)

        assert actual == expected,
               "Values did not match for field: #{field}\n expected: #{inspect(expected)}\n actual: #{inspect(actual)}"
      end

      refute user_from_db.updated_at == existing_user.updated_at
      assert %DateTime{} = user_from_db.updated_at
    end

    test "error: returns an error tuple when user can't be updated" do
      existing_user = Factory.insert(:user)
      bad_params = %{"first_name" => DateTime.utc_now()}

      assert {:error, %Changeset{}} = Users.update(existing_user, bad_params)

      assert existing_user == Repo.get(User, existing_user.id)
    end
  end

  describe "delete/1" do
    test "success: it deletes the user" do
      user = Factory.insert(:user)

      assert {:ok, _deleted_user} = Users.delete(user)

      refute Repo.get(User, user.id)
    end
  end
end
