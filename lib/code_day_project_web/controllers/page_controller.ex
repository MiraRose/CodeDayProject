defmodule CodeDayProjectWeb.PageController do
  use CodeDayProjectWeb, :controller

  def index(conn, _params) do
    
    render(conn, "index.html", content: [])
  end

  def show(conn, _params) do 
    
    repos = Map.fetch!(conn.params, "organization")
    |> getListOfRepoNames()

    render(conn, "index.html", content: repos)
  end

  def getListOfRepoNames(organizationName) do

    url = Application.get_env(:code_day_project, :github_api)
    
    response = HTTPoison.get!("#{url}/orgs/#{organizationName}/repos?type=public") 
    
    Poison.decode!(response.body)
    |> Enum.map(fn x -> x["name"] end) 

  end

end
