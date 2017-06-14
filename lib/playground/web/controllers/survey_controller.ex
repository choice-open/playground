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
    survey = PSQ.get_survey!(id)
    json conn, survey_json(survey)
  end

  def update(conn, %{"id" => id, "survey" => survey_params}) do
    survey = PSQ.get_survey!(id)

    with {:ok, %Survey{} = survey} <- PSQ.update_survey(survey, survey_params) do
      json conn, survey_json(survey)
    end
  end

  def delete(conn, %{"id" => id}) do
    survey = PSQ.get_survey!(id)
    with {:ok, %Survey{}} <- PSQ.delete_survey(survey) do
      send_resp(conn, :no_content, "")
    end
  end

  def stats(conn, %{"id" => id}) do
    survey = PSQ.get_survey!(id)
    stats =
      %{
        id: survey.id,
        title: survey.title,
        questions: questions_json(survey.id, :stats)
      }
    json conn, stats
  end

  def survey_json(survey) do
    %{
      id: survey.id,
      title: survey.title,
      questions: questions_json(survey.id),
    }
  end

  def questions_json(survey_id) do
    PSQ.list_questions(survey_id)
    |> Enum.map(fn q ->
      %{
        id: q.id,
        type: q.type,
        title: q.title,
        required: q.required,
        options: options_json(q.type, q.id),
      }
    end)
  end

  def questions_json(survey_id, :stats) do
    PSQ.list_questions(survey_id)
    |> Enum.map(fn q ->
      base =
          %{
            id: q.id,
            type: q.type,
            title: q.title,
            required: q.required,
          }

      case q.type do
        "select" ->
          options = %{options: options_json(q.type, q.id, :stats)}
          Map.merge(base, options)
        "fill" ->
          answers = PSQ.list_answers(q.id)
          total_answers = length(answers)
          non_empty_ans =
            answers
            |> Enum.reject(&(is_nil(&1.content)))
            |> length
          answers_stats =
            %{
              non_empty_answers: non_empty_ans,
              percentage: get_percentage(non_empty_ans, total_answers),
            }
          Map.merge(base, answers_stats)
      end
    end)

  end

  def options_json("fill", _question_id), do: nil
  def options_json("select", question_id) do
    PSQ.list_options(question_id)
    |> Enum.map(&(%{id: &1.id, content: &1.content}))
  end

  def options_json("select", question_id, :stats) do
    options = PSQ.list_options(question_id)
    total_selected = Enum.reduce(options, 0, fn op, acc -> acc + op.count end)
    options
    |> Enum.map(fn op ->
      %{
        id: op.id,
        content: op.content,
        count: op.count,
        percentage: get_percentage(op.count, total_selected),
      }
    end)
  end

  def get_percentage(_, 0), do: 0
  def get_percentage(num, den), do: Float.round(num / den * 100, 2)




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
