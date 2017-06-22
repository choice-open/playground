defmodule Playground.Web.Router do
  use Playground.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Playground.Web do
    pipe_through :api

    scope "/v1", as: :v1 do
      get "/surveys/:id", V1.SurveyController, :show
    end
  end
end
