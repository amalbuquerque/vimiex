defmodule Vimiex.TUI do
  @moduledoc """
  Root-module that implements our IEx TUI.

  Run it as:

  iex> Ratatouille.run(Vimiex.TUI, quit_events: [{:key, Ratatouille.Constants.key(:ctrl_d)}])

  """

  @behaviour Ratatouille.App

  import Ratatouille.View
  import Ratatouille.Constants, only: [key: 1]

  alias Vimiex.State

  @spacebar key(:space)

  @delete_keys [
    key(:delete),
    key(:backspace),
    key(:backspace2)
  ]

  def run do
    Ratatouille.run(Vimiex.TUI, quit_events: [{:key, Ratatouille.Constants.key(:ctrl_d)}])
  end

  def init(_context), do: %State{}

  def update(state, message) do
    case message do
      {:event, %{key: key}} when key in @delete_keys ->
        new_command = String.slice(state.command, 0..-2)
        %{state | command: new_command}

      {:event, %{key: @spacebar}} ->
        new_command = state.command <> " "

        %{state | command: new_command}

      {:event, %{ch: ch}} when ch > 0 ->
        new_command = state.command <> <<ch::utf8>>

        %{state | command: new_command}

      _ ->
        state
    end
  end

  def render(state) do
    mode =
      state
      |> Map.get(:mode)
      |> to_string()
      |> String.upcase()

    bottom_bar =
      bar do
        label(content: "Mode: #{mode}")
      end

    view(bottom_bar: bottom_bar) do
      panel title: "vimIEx", height: 4 do
        row do
          column(size: 12) do
            label(content: state.command <> "▌")
          end
        end
      end

      panel title: "Results", height: :fill do
        row do
          column(size: 12) do
            label(content: "Results should appear here")
          end
        end
      end
    end
  end
end
