defmodule CodeDayProjectWeb.PageController do
  use CodeDayProjectWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html", content: [], message: "Enter a organization name! (ex: github)", name: "")
  end

  def show(conn, _params) do
    organization_name = Map.fetch!(conn.params, "organization")

    with {:ok, repos} <- get_list_of_repo_names(organization_name) do
      render(conn, "index.html", content: repos, message: "", name: organization_name)
    else
      {:error, message} -> render(conn, "index.html", content: [], message: message, name: "")
    end
  end

  def get_list_of_repo_names(organization_name) do
    url = Application.get_env(:code_day_project, :github_api)

    with %HTTPoison.Response{status_code: 200} <-
           HTTPoison.get!("#{url}/orgs/#{organization_name}/repos?type=public") do
      response = HTTPoison.get!("#{url}/orgs/#{organization_name}/repos?type=public")

      repo_list =
        Poison.decode!(response.body)
        |> Enum.map(fn x -> {x["name"], x["html_url"]} end)

      {:ok, repo_list}
    else
      %HTTPoison.Response{status_code: 404} ->
        {:error, "Organization not found"}

      %HTTPoison.Response{status_code: 403} ->
        {:error, "You've talked to GitHub too much. Please try again in a bit."}

      _ ->
        {:error, "Something went wrong"}
    end
  end
end
