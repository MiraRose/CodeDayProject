defmodule CodeDayProject.Repo do
  use Ecto.Repo,
    otp_app: :code_day_project,
    adapter: Ecto.Adapters.Postgres
end
