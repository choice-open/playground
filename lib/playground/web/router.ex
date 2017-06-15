defmodule Playground.Web.Router do
  use Playground.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Playground.Web do
    pipe_through :api

    scope "/v1" do
      resources "/surveys", SurveyController, except: [:new, :edit] do
        resources "/questions", QuestionController, except: [:index, :show, :new, :edit, :update]
      end
      post "/surveys/:survey_id/questions/:question_id/answer", AnswerController, :create
      get  "/surveys/:id/stats", SurveyController, :stats, as: :survey_stats
    end
  end
end
