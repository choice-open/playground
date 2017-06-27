defmodule Playground.Web.Router do
  use Playground.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Playground.Web do
    pipe_through :api

    scope "/v1", as: :v1 do
      resources  "/surveys",  V1.SurveyController, except: [:index, :new, :create, :edit, :update, :delete] do
        resources "/answers", V1.AnswerController, except: [:index, :new, :edit, :update, :delete]
      end
      get "/surveys/:id/stats", V1.SurveyController, :stats, as: :survey_stat
    end
  end
end
