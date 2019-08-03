defmodule CodeDayProjectWeb.PageController do
  use CodeDayProjectWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html", content: [], message: "")
  end

  def show(conn, _params) do
    organizationName = Map.fetch!(conn.params, "organization")

    with {:ok, repos} <- getListOfRepoNames(organizationName) do
      render(conn, "index.html", content: repos, message: "")
    else
      {:error, message} -> render(conn, "index.html", content: [], message: message)
    end
  end

  def getListOfRepoNames(organizationName) do
    url = Application.get_env(:code_day_project, :github_api)

    with %HTTPoison.Response{status_code: 200} <-
           HTTPoison.get!("#{url}/orgs/#{organizationName}/repos?type=public") do
      response = HTTPoison.get!("#{url}/orgs/#{organizationName}/repos?type=public")

      repo_list =
        Poison.decode!(response.body)
        |> Enum.map(fn x -> x["name"] end)

      {:ok, repo_list}
    else
      %HTTPoison.Response{status_code: 404} -> {:error, "Organization not found"}
      _ -> {:error, "Something went wrong"}
    end
  end
end
