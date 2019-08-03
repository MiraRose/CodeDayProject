defmodule CodeDayProjectWeb.PageController do
  use CodeDayProjectWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html", content: [], message: "Enter a orgnization name!")
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
        |> Enum.map(fn x -> {x["name"], x["html_url"]} end)

      {:ok, repo_list}
    else
      %HTTPoison.Response{status_code: 404} -> {:error, "Organization not found"}
      %HTTPoison.Response{status_code: 403} -> {:error, "You've talked to GitHub too much. Please try again next hour."}
      _ -> {:error, "Something went wrong"}
    end
  end
end
