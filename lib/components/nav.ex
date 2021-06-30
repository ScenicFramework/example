defmodule Example.Component.Nav do
  use Scenic.Component

  alias Scenic.Graph
  alias Scenic.ViewPort

  import Scenic.Primitives, only: [{:text, 3}, {:rect, 3}]
  import Scenic.Components, only: [{:dropdown, 3}, {:toggle, 3}]

  @height 60

  # --------------------------------------------------------
  def validate(scene) when is_atom(scene), do: {:ok, scene}
  def validate({scene, _} = data) when is_atom(scene), do: {:ok, data}
  def validate(data) do
    {
      :error,
      """
      #{IO.ANSI.red()}Invalid #{inspect(__MODULE__)} specification
      Received: #{inspect(data)}
      #{IO.ANSI.yellow()}
      Nav component requires a valid scene module or {module, param}
      """
    }
  end

  # ----------------------------------------------------------------------------
  def init(scene, current_scene, opts) do
    {width, _} = scene.viewport.size

    {background, text} = case opts[:theme] do
      :dark ->
        {{48, 48, 48}, :white}

      :light ->
        {{220, 220, 220}, :black}

      _ ->
        {{48, 48, 48}, :white}
    end

    graph = Graph.build( font_size: 20 )
      |> rect( {width, @height}, fill: background )
      |> text( "Scene:", translate: {15, 38}, align: :right, fill: text )
      |> dropdown(
        {[
           {"Sensor", Example.Scene.Sensor},
           {"Primitives", Example.Scene.Primitives},
           {"Fills", Example.Scene.Fills},
           {"Strokes", Example.Scene.Strokes},
           {"Components", Example.Scene.Components},
           {"Transforms", Example.Scene.Transforms},
           {"Sprites", Example.Scene.Sprites},
         ], current_scene},
        id: :nav,
        translate: {90, 10}
      )
      |> toggle(
        opts[:theme] == :light,
        id: :light_or_dark,
        theme: :secondary,
        translate: {width - 60, 16},
      )
      # |> digital_clock(text_align: :right, translate: {width - 20, 35})


    push_graph(scene, graph)

    { :ok, scene }
  end


  # ----------------------------------------------------------------------------
  def handle_event({:value_changed, :nav, {scene_mod, param}}, _, scene) do
    ViewPort.set_root(scene.viewport, scene_mod, param)
    { :noreply, scene }
  end

  # ----------------------------------------------------------------------------
  def handle_event({:value_changed, :nav, scene_mod}, _, scene) do
    ViewPort.set_root(scene.viewport, scene_mod)
    { :noreply, scene }
  end

  # ----------------------------------------------------------------------------
  def handle_event({:value_changed, :light_or_dark, light?}, _, scene) do
    case light? do
      true -> ViewPort.set_theme(scene.viewport, :light)
      false -> ViewPort.set_theme(scene.viewport, :dark)
    end
    { :noreply, scene }
  end

end


