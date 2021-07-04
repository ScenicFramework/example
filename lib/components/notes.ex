defmodule Example.Component.Notes do
  use Scenic.Component, has_children: false

  # alias Scenic.ViewPort
  alias Scenic.Scene
  alias Scenic.Graph

  import Scenic.Primitives, only: [{:text, 3}, {:rect, 3}]

  @height 110
  @font_size 20
  @indent 30

  # --------------------------------------------------------
  def validate(notes) when is_bitstring(notes), do: {:ok, notes}

  def validate(data) do
    {
      :error,
      """
      #{IO.ANSI.red()}Invalid #{inspect(__MODULE__)} specification
      Received: #{inspect(data)}
      #{IO.ANSI.yellow()}
      Notes data should be a string
      """
    }
  end

  # ----------------------------------------------------------------------------
  def init(%Scene{viewport: viewport} = scene, notes, opts) do
    {vp_width, vp_height} = viewport.size

    {background, text} =
      case opts[:theme] do
        :dark ->
          {{48, 48, 48}, :white}

        :light ->
          {{220, 220, 220}, :black}

        _ ->
          {{48, 48, 48}, :white}
      end

    graph =
      Graph.build(
        font_size: @font_size,
        font: :roboto,
        t: {0, vp_height - @height},
        theme: opts[:theme]
      )
      |> rect({vp_width, @height}, fill: background)
      |> text(notes, translate: {@indent, @font_size * 2}, fill: text)

    {:ok, push_graph(scene, graph)}
  end
end
