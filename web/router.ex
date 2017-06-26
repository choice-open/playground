defmodule Playground.Router do
  use Playground.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Playground do
    pipe_through :api
  end
end
