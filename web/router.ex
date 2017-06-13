defmodule Playground.Router do
  use Playground.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Playground do
    pipe_through :api
  end

  scope "/v1", Playground do
    pipe_through :api

    get "/surveys", SurveyController, :index
    get "/surveys/:id", SurveyController, :show

    resources "/answers", AnswerController
  end
end
