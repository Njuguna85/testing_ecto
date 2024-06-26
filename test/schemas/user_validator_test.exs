defmodule TestingEcto.Schemas.UserValidatorTest do
  use TestingEcto.SchemaCase
  alias TestingEcto.Schemas.UserValidator

  @expected_fields_with_types [
    {:date_of_birth, :date},
    {:email, :string},
    {:favorite_number, :float},
    {:first_name, :string},
    {:last_name, :string},
    {:phone_number, :string}
  ]
  @optional [:favorite_number]

  describe "cast_and_validate/1" do
    test "success: returns a valid changeset when given valid arguments" do
      valid_params = valid_params(@expected_fields_with_types)

      {:ok, result} = UserValidator.cast_and_validate(valid_params)

      assert %UserValidator{} = result
      mutated = [:date_of_birth]

      for {field, _} <- @expected_fields_with_types, field not in mutated do
        assert Map.get(result, field) == valid_params[Atom.to_string(field)]
      end

      expected_dob = Date.from_iso8601!(valid_params["date_of_birth"])
      assert result.date_of_birth == expected_dob
    end

    test "error: returns an error changeset when given un-castable values" do
      invalid_params = invalid_params(@expected_fields_with_types)

      assert {:error, %Changeset{errors: errors}} =
               UserValidator.cast_and_validate(invalid_params)

      for {field, _} <- @expected_fields_with_types do
        assert errors[field], "The field :#{field} is missing from errors."
        {_, meta} = errors[field]

        assert meta[:validation] == :cast,
               "The validation type, #{meta[:validation]}, is incorrect"
      end
    end

    test "error: returns error changeset when required fields are missing" do
      params = %{}

      assert {:error, %Changeset{errors: errors}} = UserValidator.cast_and_validate(params)

      for {field, _} <- @expected_fields_with_types, field not in @optional do
        assert errors[field], "The field :#{field} is missing from errors."

        {_, meta} = errors[field]

        assert meta[:validation] == :required,
               "The validation type, #{meta[:validation]}, is incorrect."
      end
    end
  end
end
