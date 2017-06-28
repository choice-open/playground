defmodule Playground.Router do
  use Playground.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Playground do
    pipe_through :api

    scope "/v1", V1, as: :v1 do
      resources "/surveys", SurveyController, only: [:show] do
        resources "/results", ResultController, only: [:index, :show]
        resources "/answers", AnswerController, only: [:create]
        resources "/questions", QuestionController, only: [:index]
      end

      resources "/meta_questions", MetaQuestionController, only: [:index]
    end
  end
end
