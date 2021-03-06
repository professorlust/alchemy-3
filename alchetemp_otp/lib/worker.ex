defmodule AlchetempOtp.Worker do
  use GenServer

  # CLIENT
  def start_link(opts \\ []) do
    GenServer.start(__MODULE__, :ok, opts)
  end

  def get_temperature(pid, location) do
    GenServer.call(pid, {:location, location})
  end

  def get_state(pid) do
    GenServer.call(pid, :get_state)
  end

  def reset_state(pid) do
    GenServer.cast(pid, :reset_state)
  end

  def stop(pid) do
    GenServer.cast(pid, :stop)
  end


  # SERVER
  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:location, location}, _from, state) do
    case temperature_of(location) do
      {:ok, temp} ->
        new_state = update_state(state, location)
        {:reply, "#{temp} C", new_state}
      _error ->
        {:reply, :error, state}
    end
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def handle_cast(:reset_state, _state) do
    {:noreply, %{}}
  end

  def handle_cast(:stop, state) do
    {:stop, :normal, state}
  end

  def handle_info(msg, state) do
    IO.puts "received #{inspect msg}"
    {:noreply, state}
  end

  # CALLBACK HELPERS

  def terminate(reason, state) do
    IO.puts "server terminated because of #{inspect reason}"
    inspect state
    :ok
  end

  defp temperature_of(location) do
    url_for(location) |> HTTPoison.get |> parse_response
  end

  defp url_for(location) do
    "http://api.openweathermap.org/data/2.5/weather?q=#{location}&APPID=#{apikey}"
  end

  defp parse_response({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
    body |> JSON.decode! |> compute_temperature
  end

  defp parse_response(_) do
    :error
  end

  defp compute_temperature(json) do
    try do
      temp = (json["main"]["temp"] - 273.15) |> Float.round(1)
      {:ok, temp}
    rescue
      _ -> :error
    end
  end

  defp update_state(old_state, location) do
    case Map.has_key?(old_state, location) do
      true ->
        Map.update!(old_state, location, &(&1 + 1))
      false ->
        Map.put_new(old_state, location, 1)
    end
  end

  defp apikey do
    "3ce510c72422b3ca0b6273e052aca96d"
  end
end
