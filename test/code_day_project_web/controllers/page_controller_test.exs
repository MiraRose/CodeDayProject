defmodule CodeDayProjectWeb.PageControllerTest do
  use CodeDayProjectWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Code Day Project"
  end

  test "POST /findOrg returns name(s) of repos", %{conn: conn} do
    bypass = Bypass.open()

    fake_map = [%{"name" => "pong", "html_url" => "http://github.com/github/pong"}]
    json_fake_map = Poison.encode!(fake_map)

    Bypass.expect(bypass, fn conn ->
      Plug.Conn.resp(conn, 200, json_fake_map)
    end)

    Application.put_env(:code_day_project, :github_api, "localhost:#{bypass.port}")

    conn =
      Plug.Conn.put_req_header(conn, "content-type", "application/json")
      |> post("/findOrg", "{\"organization\": \"github\"}")

    assert html_response(conn, 200) =~ "pong"
  end

  test "POST /findOrg displays name of org searched for", %{conn: conn} do
    bypass = Bypass.open()

    fake_map = [%{"name" => "pong", "html_url" => "http://github.com/github/pong"}]
    json_fake_map = Poison.encode!(fake_map)

    Bypass.expect(bypass, fn conn ->
      Plug.Conn.resp(conn, 200, json_fake_map)
    end)

    Application.put_env(:code_day_project, :github_api, "localhost:#{bypass.port}")

    conn =
      Plug.Conn.put_req_header(conn, "content-type", "application/json")
      |> post("/findOrg", "{\"organization\": \"github\"}")

    assert html_response(conn, 200) =~ "github"
  end

  test "POST /findOrg returns name(s) of repos if organization not in lowercase", %{conn: conn} do
    bypass = Bypass.open()

    fake_map = [%{"name" => "pong", "html_url" => "http://github.com/github/pong"}]
    json_fake_map = Poison.encode!(fake_map)

    Bypass.expect(bypass, fn conn ->
      Plug.Conn.resp(conn, 200, json_fake_map)
    end)

    Application.put_env(:code_day_project, :github_api, "localhost:#{bypass.port}")

    conn =
      Plug.Conn.put_req_header(conn, "content-type", "application/json")
      |> post("/findOrg", "{\"organization\": \"Github\"}")

    assert html_response(conn, 200) =~ "pong"
  end

  test "POST /findOrg returns repos with urls", %{conn: conn} do
    bypass = Bypass.open()

    fake_map = [%{"name" => "pong", "html_url" => "http://github.com/github/pong"}]
    json_fake_map = Poison.encode!(fake_map)

    Bypass.expect(bypass, fn conn ->
      Plug.Conn.resp(conn, 200, json_fake_map)
    end)

    Application.put_env(:code_day_project, :github_api, "localhost:#{bypass.port}")

    conn =
      Plug.Conn.put_req_header(conn, "content-type", "application/json")
      |> post("/findOrg", "{\"organization\": \"github\"}")

    assert html_response(conn, 200) =~ "http://github.com/github/pong"
  end

  test "POST /findOrg returns correct number of names in list", %{conn: conn} do
    bypass = Bypass.open()

    fake_map = [%{"name" => "pong", "html_url" => "http://github.com/github/pong"}]
    json_fake_map = Poison.encode!(fake_map)

    Bypass.expect(bypass, fn conn ->
      Plug.Conn.resp(conn, 200, json_fake_map)
    end)

    Application.put_env(:code_day_project, :github_api, "localhost:#{bypass.port}")

    conn =
      Plug.Conn.put_req_header(conn, "content-type", "application/json")
      |> post("/findOrg", "{\"organization\": \"github\"}")

    assert html_response(conn, 200) =~ "Repositories found: 1"
  end

  test "POST /findOrg doesn't return number in list when there's an error", %{conn: conn} do
    bypass = Bypass.open()

    fake_map = [%{"name" => "pong", "html_url" => "http://github.com/github/pong"}]
    json_fake_map = Poison.encode!(fake_map)

    Bypass.expect(bypass, fn conn ->
      Plug.Conn.resp(conn, 404, json_fake_map)
    end)

    Application.put_env(:code_day_project, :github_api, "localhost:#{bypass.port}")

    conn =
      Plug.Conn.put_req_header(conn, "content-type", "application/json")
      |> post("/findOrg", "{\"organization\": \"github\"}")

    refute html_response(conn, 200) =~ "Repositories found:"
  end

  test "POST /findOrg returns nothing found when nothing found", %{conn: conn} do
    bypass = Bypass.open()

    Bypass.expect(bypass, fn conn ->
      Plug.Conn.resp(conn, 404, "Resource not found")
    end)

    Application.put_env(:code_day_project, :github_api, "localhost:#{bypass.port}")

    conn =
      Plug.Conn.put_req_header(conn, "content-type", "application/json")
      |> post("/findOrg", "{\"organization\": \"notAOrg\"}")

    assert html_response(conn, 200) =~ "Organization not found"
  end

  test "POST /findOrg returns something went wrong for server problem", %{conn: conn} do
    bypass = Bypass.open()

    Bypass.expect(bypass, fn conn ->
      Plug.Conn.resp(conn, 500, "Something went wrong with the server")
    end)

    Application.put_env(:code_day_project, :github_api, "localhost:#{bypass.port}")

    conn =
      Plug.Conn.put_req_header(conn, "content-type", "application/json")
      |> post("/findOrg", "{\"organization\": \"notAOrg\"}")

    assert html_response(conn, 200) =~ "Something went wrong"
  end

  test "POST /findOrg returns that you've hit rate limit", %{conn: conn} do
    bypass = Bypass.open()

    Bypass.expect(bypass, fn conn ->
      Plug.Conn.resp(conn, 403, "You've pulled too much for this hour")
    end)

    Application.put_env(:code_day_project, :github_api, "localhost:#{bypass.port}")

    conn =
      Plug.Conn.put_req_header(conn, "content-type", "application/json")
      |> post("/findOrg", "{\"organization\": \"notAOrg\"}")

    assert html_response(conn, 200) =~ "talked to GitHub too much."
  end
end
