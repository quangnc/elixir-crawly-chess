# defmodule HttpClient do
#  def fetch_login do
#    chess_login |> handle_response()
#  end
#
#  defp chess_url do
#    "https://users.chessbase.com/"
#  end
#
#  defp handle_response({:ok, %{status_code: 200, body: body}}) do
#    {:ok, body}
#  end
#
#  defp handle_response({:error, %{status_code: sc, body: body}}) do
#    {:error, sc, body}
#  end
#
#  defp handle_response({ec, %{status_code: sc, body: body}}) do
#    {ec, sc, body}
#  end
#
#  def post_body() do
#    user = "Z2FtZXRodTEyMw=="
#    pass = "TWF0S2hhdUAxMjM="
#
#    %{
#      cmd: "get",
#      user: "Z2FtZXRodTEyMw==",
#      app: "database",
#      pass: "TWF0S2hhdUAxMjM=",
#      key: get_cmd_key(user, "chk")
#    }
#  end
##
##  def chess_login() do
##    HTTPoison.post(chess_url(), post_body(), %{
##      "Content-Type" => "application/x-www-form-urlencoded",
##      "Cache-Control" => "no-cache"
##    })
##  end
#
#  # name is string base64
#  def get_cmd_key(name, cmd \\ "chk") do
#    full_name = "#{cmd}#{name}" |> String.reverse()
#
#    <<full_name_1::binary-size(1), full_name_2::binary-size(1), full_name_3::binary-size(1),
#      rest::binary>> = full_name
#
#    <<cmd_1::binary-size(1), cmd_2::binary-size(1), cmd_3::binary-size(1), rest_cmd::binary>> =
#      cmd
#
#    (full_name_1 <> cmd_1 <> full_name_2 <> cmd_2 <> full_name_3 <> cmd_3 <> rest)
#    |> Base.encode64()
#  end
# end
