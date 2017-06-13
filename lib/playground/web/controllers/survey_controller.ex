defmodule Playground.Web.SurveyController do
  use Playground.Web, :controller

  alias Playground.PSQ
  alias Playground.PSQ.Survey

  action_fallback Playground.Web.FallbackController

  def index(conn, _params) do
    surveys =
      PSQ.list_surveys()
      |> Enum.map(&survey_json/1)

    json conn, surveys
  end

  def create(conn, %{"survey" => survey_params}) do
    with {:ok, %Survey{} = survey} <- PSQ.create_survey(survey_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", survey_path(conn, :show, survey))
      |> json(%{id: survey.id})
    end
  end

  def show(conn, %{"id" => id}) do
    survey = PSQ.get_survey!(id) |> IO.inspect
    json conn, survey_json(survey)
  end

  def update(conn, %{"id" => id, "survey" => survey_params}) do
    survey = PSQ.get_survey!(id)

    with {:ok, %Survey{} = survey} <- PSQ.update_survey(survey, survey_params) do
      render(conn, "show.json", survey: survey)
    end
  end

  def delete(conn, %{"id" => id}) do
    survey = PSQ.get_survey!(id)
    with {:ok, %Survey{}} <- PSQ.delete_survey(survey) do
      send_resp(conn, :no_content, "")
    end
  end

  def survey_json(survey) do
      %{
        id: survey.id,
        title: survey.title,
      }
  end


  defp demo_survey do
    %{
      id: 1,
      title: "程序员信仰测试",
      questions: [
        %{
          id: 1,
          type: "select",
          title: "请选择你最喜欢的语言",
          required: true,
          options: [
            %{
              id: 1,
              content: "PHP"
            },
            %{
              id: 2,
              content: "Ruby"
            },
            %{
              id: 3,
              content: "Elixir"
            },
            %{
              id: 4,
              content: "JavaScript"
            }
          ]
        },
        %{
          id: 2,
          type: "fill",
          title: "请填写你喜欢它的原因",
          required: false,
        }
      ]
    }
  end


end
