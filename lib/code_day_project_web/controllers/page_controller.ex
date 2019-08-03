defmodule CodeDayProjectWeb.PageController do
  use CodeDayProjectWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html",
      content: [],
      message: "Enter a organization name! (ex: github)",
      name: ""
    )
  end

  def show(conn, _params) do
    with organization_name <- Map.fetch!(conn.params, "organization"),
         {:ok, repos} <- get_list_of_repo_names(organization_name) do
      render(conn, "index.html", content: repos, message: "", name: organization_name)
    else
      {:error, message} -> render(conn, "index.html", content: [], message: message, name: "")
    end
  end

  def get_list_of_repo_names(organization_name) do
    with url <- Application.get_env(:code_day_project, :github_api),
         %HTTPoison.Response{status_code: 200, body: body} <-
           HTTPoison.get!("#{url}/orgs/#{organization_name}/repos?type=public") do
      repo_list =
        Poison.decode!(body)
        |> Enum.map(fn %{"name" => name, "html_url" => url} -> {name, url} end)

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
