defmodule CodeDayProjectWeb.PageView do
  use CodeDayProjectWeb, :view

  def getAPI() do
    Poison.decode(HTTPoison.get!("https://api.github.com/orgs/octokit/repos"))
    # Poison.decode(response)
  end
end
