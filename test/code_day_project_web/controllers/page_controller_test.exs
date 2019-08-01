defmodule CodeDayProjectWeb.PageControllerTest do
  use CodeDayProjectWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Code Day Project for ScriptDrop"
  end

  test "POST /findOrg", %{conn: conn} do

    bypass = Bypass.open()

    fakeMap = [%{"name" => "pong"}]
    jsonFakeMap = Poison.encode!(fakeMap)

    Bypass.expect(bypass, fn conn ->
      Plug.Conn.resp(conn, 200, jsonFakeMap)
    end)

    Application.put_env(:code_day_project, :github_api, "localhost:#{bypass.port}")
    conn = Plug.Conn.put_req_header(conn, "content-type", "application/json")
    |> post("/findOrg", "{\"organization\": \"github\"}")
    
    assert html_response(conn, 200) =~ "pong"
  end

end
