defmodule TestSchemas.Schemas.UserDatabaseSchemaTest do
  use TestingEcto.SchemaCase
  alias TestingEcto.Schemas.UserDatabaseSchema

  @expected_fields_with_types [
    {:id, :binary_id},
    {:date_of_birth, :date},
    {:email, :string},
    {:favorite_number, :float},
    {:first_name, :string},
    {:last_name, :string},
    {:phone_number, :string},
    {:inserted_at, :utc_datetime_usec},
    {:updated_at, :utc_datetime_usec}
  ]
  @optional [:id, :favorite_number]

  describe "fields and types" do
    @tag :schema_definition

    test "it has the correct fields and types" do
      actual_fields_with_types =
        for field <- UserDatabaseSchema.__schema__(:fields) do
          type = UserDatabaseSchema.__schema__(:type, field)
          {field, type}
        end

      assert MapSet.new(actual_fields_with_types) == MapSet.new(@expected_fields_with_types)
    end
  end

  describe "changeset/1" do
    test "success: returns a valid changeset when given valid arguments" do
      valid_params = valid_params(@expected_fields_with_types)

      changeset = UserDatabaseSchema.changeset(valid_params)
      assert %Changeset{valid?: true, changes: changes} = changeset

      mutated = [:date_of_birth]

      for {field, _} <- @expected_fields_with_types, field not in mutated do
        actual = Map.get(changes, field)
        expected = valid_params[Atom.to_string(field)]

        assert actual == expected,
               "Values did not match for field: #{field}\nexpected: #{inspect(expected)}\nactual: #{inspect(actual)}"
      end

      expected_dob = Date.from_iso8601!(valid_params["date_of_birth"])
      assert changes.date_of_birth == expected_dob
    end

    test "error: returns an error changeset when given un-castable value" do
      invalid_params = invalid_params(@expected_fields_with_types)

      assert %Changeset{valid?: false, errors: errors} =
               UserDatabaseSchema.changeset(invalid_params)

      for {field, _} <- @expected_fields_with_types do
        assert errors[field], "The field :#{field} is missing from errors."
        {_, meta} = errors[field]

        assert meta[:validation] == :cast,
               "The validation type, #{meta[:validation]}, is incorrect."
      end
    end

    test "error: returns error changeset when required fields are missing" do
      params = %{}

      assert %Changeset{valid?: false, errors: errors} = UserDatabaseSchema.changeset(params)

      for {field, _} <- @expected_fields_with_types, field not in @optional do
        assert errors[field], "Field #{inspect(field)} is missing from errors."
        {_, meta} = errors[field]

        assert meta[:validation] == :required,
               "The validation type, #{meta[:validation]}, is incorrect."
      end

      for {field, _} <- @optional do
        refute errors[field],
               "The optional field #{field} is required when it shouldn't be."
      end
    end

    test "error: returns error changeset when an email address is reused" do
      {:ok, existing_user} =
        valid_params(@expected_fields_with_types)
        |> UserDatabaseSchema.changeset()
        |> TestingEcto.Repo.insert()

      changeset_with_repeated_email =
        valid_params(@expected_fields_with_types)
        |> Map.put("email", existing_user.email)
        |> UserDatabaseSchema.changeset()

      assert {:error, %Changeset{valid?: false, errors: errors}} =
               TestingEcto.Repo.insert(changeset_with_repeated_email)

      assert errors[:email], "The field :email is missing from errors."
      {_, meta} = errors[:email]

      # IO.inspect(inspect({errors}), label: "errors")
      # IO.inspect(inspect(errors[:email]), "email errors")
      # IO.inspect(inspect(meta), label: "meta")

      assert meta[:constraint] == :unique,
             "The validation type, #{meta[:validation]}, is incorrect."
    end
  end
end
