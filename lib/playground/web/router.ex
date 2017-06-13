defmodule Playground.Web.Router do
  use Playground.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Playground.Web do
    pipe_through :api

    scope "/v1" do
      resources "/surveys", SurveyController, except: [:new, :edit]
    end
  end
end
