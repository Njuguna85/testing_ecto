defmodule TestingEcto.Factory do
  # this means that this factory will be usable specifically with the repo passed
  use ExMachina.Ecto, repo: TestingEcto.Repo
  alias TestingEcto.Schemas.User

  # Rule of thumb: if a function is focused on making data,
  # it can go into a factory.
  # if not, it might belong to a case template.
  # If you find the same function is needed in multiple case templates,
  # then you may have a candidate for a module with helper functions that
  # can be pulled into multiple case templates

  # ex_machina uses meta-programming under the hood and thus to make it work
  # we use the conventionL "_factory"
  #
  # this function returns a schema struct with pre-populated values
  def user_factory do
    %User{
      date_of_birth: to_string(Faker.Date.date_of_birth()),
      email: Faker.Internet.email(),
      favorite_number: :rand.uniform() * 10,
      first_name: Faker.Person.first_name(),
      last_name: Faker.Person.last_name(),
      phone_number: Faker.Phone.EnUs.phone()
    }
  end
end
