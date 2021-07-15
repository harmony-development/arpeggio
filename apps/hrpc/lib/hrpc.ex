# SPDX-FileCopyrightText: 2021 Carson Black <uhhadd@gmail.com>
# SPDX-FileCopyrightText: 2021 Danil Korennykh <bluskript@gmail.com>
#
# SPDX-License-Identifier: AGPL-3.0-or-later

defmodule HRPC.Codegen do
  def stream_only(it) do
    it |> Enum.filter(fn item ->
      case item do
        {_, _, true, true, _, _} -> true
        {_, _, false, true, _, _} -> true
        _ -> false
      end
    end)
  end
  def generate_socket_config(endpoints, usingModule) do
    endpoints |> stream_only |> Enum.map(fn item ->
      { _name, route, _, _, _, _} = item

      { route, usingModule, [] }
    end)
  end

  @spec generate_endpoints(list(tuple()), module()) :: Macro.t()
  defmacro generate_endpoints(endpoints, usingModule) do
    {it, _} = Code.eval_quoted(endpoints, [], __ENV__)
    {mod, _} = Code.eval_quoted(usingModule, [], __ENV__)

    it |> Enum.map(fn item ->
      case item do
        {name, _route, false, false, input, output} ->
          quote location: :keep do
            def unquote(name |> Macro.underscore |> String.to_atom)(conn, params) do
              import Logger

              {:ok, body, conn} = conn |> Plug.Conn.read_body()
              parsed = unquote(input).decode(body)

              try do
                case unquote(mod).unquote(name |> Macro.underscore |> String.to_atom)(parsed) do
                  {:ok, data} ->
                    conn
                    |> put_resp_content_type("application/hrpc", nil)
                    |> send_resp(200, data |> unquote(output).encode())
                  {:error, reason} -> conn |> send_resp(400, reason)
                  it ->
                    IO.inspect it
                    raise "unhandled return"
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
          quote location: :keep do
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
          quote location: :keep do
            post unquote(route), unquote(controller), unquote(name |> Macro.underscore |> String.to_atom)
          end
          _ -> quote location: :keep do
          end
      end
    end)
  end

end

defmodule HRPC.Socket do
  import HRPC.Codegen

  defp generate_stream_endpoints(it, module) do
    a = it |> stream_only |> Enum.map(fn item ->
      case item do
        # bidirectional
        {name, route, true, true, input, output} ->
          quote location: :keep do
            @impl :cowboy_websocket
            def websocket_handle({:binary, data}, %{hrpc_path: unquote(route)} = state) do
              msg = unquote(input).decode(data)

              case unquote(module).unquote(String.to_atom((name |> Macro.underscore) <> "_handle"))(msg, state) do
                {:ok, state} -> {:ok, state}
                {:reply, out, state} ->
                  reply = unquote(output).encode(out)
                  {:reply, {:binary, reply}, state}
                {:stop, state} ->
                  {:stop, state}
                _ -> throw "unhandled return"
              end
            end
            @impl :cowboy_websocket
            def websocket_info(info, %{hrpc_path: unquote(route)} = state) do
              case unquote(module).unquote(String.to_atom((name |> Macro.underscore) <> "_info"))(info, state) do
                {:ok, state} -> {:ok, state}
                {:reply, out, state} ->
                  reply = unquote(output).encode(out)
                  {:reply, {:binary, reply}, state}
                {:stop, state} ->
                  {:stop, state}
                _ -> throw "unhandled return"
              end
            end
          end
        # unidirectional
        {name, route, false, true, input, output} ->
          quote location: :keep do
            @impl :cowboy_websocket
            def websocket_handle({:binary, data}, %{hrpc_path: unquote(route)} = state) do
              case state[:hrpc_done] do
                false ->
                  msg = unquote(input).decode(data)
                  case unquote(module).unquote(String.to_atom((name |> Macro.underscore) <> "_req"))(msg, state) do
                    {:ok, state} -> {:ok, %{state | hrpc_done: true}}
                    {:reply, out, state} ->
                      reply = unquote(output).encode(out)
                      {:reply, {:binary, reply}, %{state | hrpc_done: true}}
                    {:stop, state} ->
                      {:stop, %{state | hrpc_done: true}}
                    _ -> throw "unhandled return"
                  end
                _ -> {:ok, state}
              end
            end
            @impl :cowboy_websocket
            def websocket_info(info, %{hrpc_path: unquote(route)} = state) do
              case unquote(module).unquote(String.to_atom((name |> Macro.underscore) <> "_info"))(info, state) do
                {:ok, state} -> {:ok, state}
                {:reply, out, state} ->
                  reply = unquote(output).encode(out)
                  {:reply, {:binary, reply}, state}
                {:stop, state} ->
                  {:stop, state}
                _ -> throw "unhandled return"
              end
            end
          end
        _ -> quote location: :keep do
        end
      end
    end)

    a
  end
  defmacro __using__(opts) do
    {epoints, _} = Code.eval_quoted(opts[:is], [], __ENV__)
    module = opts[:using_module]
    quotes = generate_stream_endpoints(epoints, module)

    inits = epoints |> stream_only |> Enum.map(fn it ->
      {name, route, _, _, _, _} = it

      quote location: :keep do
        def dispatch_init(unquote(route), req, state) do
          case unquote(module).unquote(String.to_atom((name |> Macro.underscore) <> "_init"))(req, state) do
            {:ok, state} -> {:cowboy_websocket, req, state}
            _ -> {:stop, state}
          end
        end
      end
    end)

    pre = [quote location: :keep do
      @behaviour :cowboy_websocket

      def dispatch_init(route, req, state) do
        throw "bad handler"
      end

      @impl :cowboy_websocket
      def init(req, _state) do
        dispatch_init(:cowboy_req.path(req), req, %{hrpc_path: :cowboy_req.path(req), hrpc_done: false})
      end

      @impl :cowboy_websocket
      def websocket_init(state) do
        {:ok, state}
      end

      @impl :cowboy_websocket
      def terminate(reason, req, state) do
        :ok
      end
    end]
    post = [quote location: :keep do
      @impl :cowboy_websocket
      def websocket_handle({:binary, data}, state) do
        {:ok, state}
      end

      @impl :cowboy_websocket
      def websocket_info(info, state) do
        {:ok, state}
      end
    end]

    inits ++ pre ++ quotes ++ post
  end
end
