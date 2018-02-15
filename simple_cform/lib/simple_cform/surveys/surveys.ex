defmodule SimpleCform.Surveys do
  @moduledoc """
  The Surveys context.
  """

  import Ecto.Query, warn: false
  alias SimpleCform.Repo

  alias SimpleCform.Surveys.Response
  alias SimpleCform.Surveys.SelectAnswer
  alias SimpleCform.Surveys.FillAnswer

  @doc """
  It's an in-memory repo,
  which always returns the same result.
  """
  def get_survey!(id) when is_binary(id) do
    id |> String.to_integer() |> get_survey!()
  end

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
  def create_response(params) do
    changeset =
      %Response{}
      |> Response.changeset(params)

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

          {:ok, %{survey_id: params["survey_id"], answers: answers}}

        {:error, failed_question_id, failed_answer, _} ->
          {:error, failed_question_id, failed_answer}
      end
    else
      {:error, changeset.errors}
    end
  end

  def get_statistics(survey_id) do
    survey_id
    |> get_survey!()
    |> Map.fetch!(:questions)
    |> Enum.map(&get_question_statistic/1)
  end

  defp get_question_statistic(%{type: "select", id: question_id, options: options}) do
    %{
      question_id: question_id,
      options: options |> Enum.map(&get_option_statistic(question_id, &1))
    }
  end

  defp get_question_statistic(%{type: "fill", id: question_id}) do
    total = question_id |> FillAnswer.count() |> Repo.one()
    non_empty = question_id |> FillAnswer.non_empty_count() |> Repo.one()

    %{
      question_id: question_id,
      content: %{non_empty: non_empty, percentage: non_empty / total * 100}
    }
  end

  defp get_option_statistic(question_id, %{id: option_id}) do
    # NOTE: N+1 query here, but i think we don't have many options now, so it's
    # acceptable for now
    total = question_id |> SelectAnswer.count() |> Repo.one()
    selected = question_id |> SelectAnswer.count_option(option_id) |> Repo.one()

    %{id: option_id, selected: selected, percentage: selected / total * 100}
  end
end
