defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  def mount(_params, session, socket) do
    {:ok,
     assign(socket,
       random_number: random_number(),
       score: 0,
       match: false,
       message: "Make A Guess:",
       session_id: session["live_socket_id"]
     )}
  end

  def handle_event("guess", %{"number" => guess}, socket) do
    IO.puts(socket.assigns.random_number)

    cond do
      guess |> String.to_integer() !== socket.assigns.random_number ->
        score = socket.assigns.score - 1
        {:noreply, assign(socket, score: score)}

      true ->
        score = socket.assigns.score + 1
        {:noreply, assign(socket, score: score, match: true)}
    end
  end

  defp random_number do
    :rand.uniform(10)
  end
end
