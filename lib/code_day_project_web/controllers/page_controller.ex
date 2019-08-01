defmodule CodeDayProjectWeb.PageController do
  use CodeDayProjectWeb, :controller

  def index(conn, _params) do
    content = []
    render(conn, "index.html", content: content)
  end

  def show(conn, _params) do
    url = Application.get_env(:code_day_project, :github_api)
    content = conn.params 
    organizationName = Map.fetch!(content, "organization")
    response = HTTPoison.get!("#{url}/orgs/#{organizationName}/repos?type=public") 
    decodedAPIMap = Poison.decode!(response.body)
    repos = Enum.map(decodedAPIMap, fn x -> x["name"] end) 
    render(conn, "index.html", content: repos)
  end


end
