defmodule SimpleCformWeb.Router do
  use SimpleCformWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", SimpleCformWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :index)
  end

  # Other scopes may use custom stacks.
  scope "/v1", SimpleCformWeb do
    pipe_through(:api)

    resources("/surveys", SurveyController, only: [:show])
  end
end
