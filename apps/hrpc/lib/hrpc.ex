# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
# SPDX-FileCopyrightText: 2021 Danil Korennykh <bluskript@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule HRPC.Codegen do
  @spec generate_endpoints(list(tuple()), module()) :: Macro.t()
  defmacro generate_endpoints(endpoints, usingModule) do
    {it, _} = Code.eval_quoted(endpoints, [], __ENV__)
    {mod, _} = Code.eval_quoted(usingModule, [], __ENV__)

    it |> Enum.map(fn item ->
      case item do
        {name, _route, false, false, input, output} ->
          quote do
            def unquote(String.to_atom(name))(conn, params) do
              import Logger

              {:ok, body, conn} = conn |> Plug.Conn.read_body()
              parsed = unquote(input).decode(body)

              try do
                case unquote(mod).unquote(name |> Macro.underscore |> String.to_atom)(parsed) do
                  {:ok, data} -> conn |> send_resp(200, data |> unquote(output).encode())
                  {:error, reason} -> conn |> send_resp(400, reason)
                end
              rescue
                e ->
                  Logger.error("Exception: #{inspect(e)}")
                  Logger.error(Exception.format_stacktrace())
                  conn |> send_resp(500, "internal server error")
              end
            end
          end
        _ ->
          quote do
          end
      end
    end)
  end

  @spec generate_phoenix_routing(list(tuple()), module()) :: Macro.t()
  defmacro generate_phoenix_routing(endpoints, controller) do
    {it, _} = Code.eval_quoted(endpoints, [], __ENV__)

    it |> Enum.map(fn item ->
      case item do
        {name, route, false, false, _input, _output} ->
          quote do
            post unquote(route), unquote(controller), unquote(String.to_atom(name))
          end
          _ -> quote do
          end
      end
    end)
  end

end
