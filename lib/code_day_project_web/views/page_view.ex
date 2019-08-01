defmodule CodeDayProjectWeb.PageView do
  use CodeDayProjectWeb, :view

  def getAPI() do
    HTTPoison.get!("https://api.github.com")
  end
end
