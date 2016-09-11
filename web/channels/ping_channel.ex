defmodule Review.PingChannel do
  use Phoenix.Channel

  import Ecto.Query

  def join(_channel, _auth, socket) do
    {:ok, _} = :timer.send_interval(1 * 1000, :send_ping)
    {:ok, socket}
  end

  def handle_info(:send_ping, socket) do
    push socket, "ping", %{}
    {:noreply, socket}
  end
end
