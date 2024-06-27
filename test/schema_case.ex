defmodule TestingEcto.SchemaCase do
  # this helps define a module template to be used through the test suite
  use ExUnit.CaseTemplate

  # This is useful when there are a set of setup callbacks or a set of functions that should be shared between test modules.

  # a using block is used to execute code during compilation
  using do
    quote do
      # We alias changeset into this case template because all future schema tests will need it
      alias Ecto.Changeset

      # when we add the helper functions, anything that 'uses' the template will get those functions
      import TestingEcto.SchemaCase
    end
  end

  # returns a string-keyed map of valid parameters
  # which are built dynamically based of the list of fields and types passed to it
  def valid_params(fields_with_types) do
    valid_value_by_type = %{
      date: fn -> to_string(Faker.Date.date_of_birth()) end,
      float: fn -> :rand.uniform() * 10 end,
      string: fn -> Faker.Lorem.word() end,
      utc_datetime_usec: fn -> DateTime.utc_now() end,
      binary_id: fn -> Ecto.UUID.generate() end
    }

    # the anonymous functions yield realistically shape different values for the new field from Faker
    for {field, type} <- fields_with_types, into: %{} do
      {Atom.to_string(field), valid_value_by_type[type].()}
    end
  end

  def invalid_params(field_with_types) do
    invalid_value_by_type = %{
      date: fn -> Faker.Lorem.word() end,
      float: fn -> Faker.Lorem.word() end,
      string: fn -> DateTime.utc_now() end,
      utc_datetime_usec: fn -> Faker.Lorem.word() end,
      binary_id: fn -> 1 end
    }

    for {field, type} <- field_with_types, into: %{} do
      {Atom.to_string(field), invalid_value_by_type[type].()}
    end
  end
end
