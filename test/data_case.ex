defmodule TestingEcto.DataCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias Ecto.Changeset
      import TestingEcto.DataCase

      # these below are needed for query tests
      alias TestingEcto.{Factory, Repo}
    end
  end

  # it provides the common sandbox setup where each setup can have access
  # to the database on manual setup
  setup _tags? do
    Ecto.Adapters.SQL.Sandbox.mode(TestingEcto.Repo, :manual)
  end
end
