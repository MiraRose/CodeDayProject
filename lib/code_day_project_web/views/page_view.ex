defmodule CodeDayProjectWeb.PageView do
  use CodeDayProjectWeb, :view

  def getAPI() do
    apiStuff = HTTPoison.get!("https://api.github.com/orgs/github/repos?type=public")
    decodedAPI = Poison.decode!(apiStuff.body)
    names = Enum.map(decodedAPI, fn x -> x["name"] end)
    
    # %HTTPoison.Response{status_code: 200,
    #                 headers: [{"content-type", "application/json"}],
    #                 body: "{...}"}
  end


  
end

# defmodule GitHub do
#   use HTTPoison.Base

#   @endpoint "https://api.github.com"

#   def process_url(url) do
#     @endpoint <> url
#   end
# end