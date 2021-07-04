use Mix.Config

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Configure the main viewport for the Scenic application
config :example, :viewport,
  name: :main_viewport,
  size: {800, 600},
  theme: :dark,
  default_scene: Example.Scene.Sensor,
  drivers: [
    [
      module: Scenic.Driver.Glfw,
      name: :glfw_driver,
      title: "Super Test Window",
      resizeable: false
      # on_close: :stop_driver
    ]
  ]
