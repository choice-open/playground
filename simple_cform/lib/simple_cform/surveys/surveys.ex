defmodule SimpleCform.Surveys do
  @moduledoc """
  The Surveys context.
  """

  import Ecto.Query, warn: false
  alias SimpleCform.Repo

  alias SimpleCform.Surveys.Response

  @doc """
  It's an in-memory repo,
  which always returns the same result.
  """
  def get_survey!(1) do
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
          required: false
        }
      ]
    }
  end

  def get_survey!(id) do
    %{id: id, questions: []}
  end

  @doc """
  Creates a response for a existing survey.
  """
  def create_response(survey, answers_attrs) do
    changeset =
      %Response{}
      |> Response.changeset(%{survey_id: survey.id, answers: answers_attrs})

    if changeset.valid? do
      changeset
      |> Response.to_multi()
      |> Repo.transaction()
      |> case do
        {:ok, changes} ->
          answers =
            changes
            |> Map.values()
            |> Enum.sort_by(fn answer -> answer.question_id end)

          {:ok, %{survey_id: survey.id, answers: answers}}

        {:error, failed_question_id, failed_answer, _} ->
          {:error, failed_question_id, failed_answer}
      end
    else
      {:error, changeset.errors}
    end
  end
end
