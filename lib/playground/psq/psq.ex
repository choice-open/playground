defmodule Playground.Psq do
  @moduledoc """
  The boundary for the Psq system.
  """

  require IEx

  import Ecto.Query, warn: false
  alias Playground.Repo

  alias Playground.Psq.Answer
  alias Playground.Psq.FillAnswerDetail
  alias Playground.Psq.SelectAnswerDetail

  def list_answers(survey_id) do
    Repo.all(Answer)
    query = from ans in Answer,
      where: ans.survey_id == ^survey_id,
      preload: [:fill_answer_details, :select_answer_details]

    Repo.all(query)
  end

  def get_answer!(survey_id, id) do
    query = from ans in Answer,
      where: ans.survey_id == ^survey_id and ans.id == ^id,
      preload: [:fill_answer_details, :select_answer_details]

    Repo.one!(query)
  end

  def create_answer(params) do
    answer_details =
      params["answers"]
      |> Enum.map(fn one ->
        build_answer_detail(one)
      end)
      |> List.flatten()

    fill_answer_details =
      answer_details
      |> Enum.filter(& match?(%FillAnswerDetail{}, &1))

    select_answer_details =
      answer_details
      |> Enum.filter(& match?(%SelectAnswerDetail{}, &1))

    %Answer{
      survey_id: String.to_integer(params["survey_id"]),
      fill_answer_details: fill_answer_details,
      select_answer_details: select_answer_details,
    } |> Repo.insert()

  end

  def build_answer_detail(answer = %{"question_type" => "fill"}) do
    %FillAnswerDetail{
      content: empty_to_nil(String.trim(answer["content"])),
      question_id: String.to_integer(answer["question_id"]),
      question_type: answer["question_type"],
    }
  end

  def build_answer_detail(answer = %{"question_type" => "select"}) do
    answer["options"]
    |> Enum.map(fn option ->
      %SelectAnswerDetail{
        content: option["content"],
        option_id: String.to_integer(option["id"]),
        selected: option["selected"],
        question_id: String.to_integer(answer["question_id"]),
        question_type: answer["question_type"],
      }
    end)
  end

  def delete_answer(%Answer{} = answer) do
    Repo.delete(answer)
  end

  defp empty_to_nil(""),  do: nil
  defp empty_to_nil(str), do: str

end
