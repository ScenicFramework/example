defmodule Example.Scene.Sensor do
  use Scenic.Scene

  alias Scenic.Graph

  import Scenic.Primitives
  import Scenic.Components

  alias Example.Component.Nav
  alias Example.Component.Notes

  @body_offset 80
  @font_size 140
  @degrees "°"

  @notes """
    \"Sensor\" is a simple scene that displays data from a simulated sensor.
    The sensor is in /lib/sensors/temperature and uses Scenic.Sensor
    The buttons are placeholders showing custom alignment.
  """

  @pubsub_data {Scenic.PubSub, :data}

  @moduledoc """
  This version of `Sensor` illustrates using spec functions to
  construct the display graph. Compare this with `Sensor` which uses
  anonymous functions.
  """

  # import IEx

  # ============================================================================
  # setup

  # --------------------------------------------------------
  def init(scene, _param, _opts) do
    {vp_width, _} = scene.viewport.size
    col = vp_width / 6

    # build the graph
    graph = Graph.build(font: :roboto, font_size: 16)
      # text input
      |> group(
        fn graph ->
          graph
          |> text(
            "16" <> @degrees,
            id: :temperature,
            text_align: :center,
            font: :roboto,
            font_size: @font_size,
            translate: {vp_width / 2, @font_size}
          )
          |> group(
            fn g ->
              g
              |> button("Calibrate", width: col * 4, height: 46, theme: :primary, id: :calibrate)
              |> button(
                "Maintenance",
                width: col * 2 - 6,
                height: 46,
                theme: :secondary,
                translate: {0, 60}
              )
              |> button(
                "Settings",
                width: col * 2 - 6,
                height: 46,
                theme: :secondary,
                translate: {col * 2 + 6, 60}
              )
            end,
            translate: {col, @font_size + 60},
            button_font_size: 24
          )
        end,
        translate: {0, @body_offset}
      )
      # NavDrop and Notes are added last so that they draw on top
      |> Nav.add_to_graph(__MODULE__)
      |> Notes.add_to_graph(@notes)

    # subscribe to the simulated temperature sensor
    Scenic.PubSub.subscribe( :temperature )

    scene =
      scene
      |> assign( graph: graph )
      |> push_graph( graph )

    { :ok, scene }
  end

  def handle_event( event, from, scene ) do
    IO.inspect( {event, from}, label: "Sensor.handle_event" )
    { :noreply, scene }
  end


  # --------------------------------------------------------
  # receive updates from the simulated temperature sensor
  def handle_info({@pubsub_data, {:temperature, kelvin, _}}, %{assigns: %{graph: graph}} = scene) do
    temperature =
      # (9 / 5 * (kelvin - 273) + 32)     # Fahrenheit
      (kelvin - 273)                      # Celsius
      |> :erlang.float_to_binary(decimals: 1)

    # center the temperature on the viewport
    graph = Graph.modify(graph, :temperature, &text(&1, temperature <> @degrees))

    scene =
      scene
      |> assign( graph: graph )
      |> push_graph( graph )

    {:noreply, scene}
  end

end
