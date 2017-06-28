defmodule Playground.HelpFunc do
  alias Playground.Repo
  alias Playground.Answer
  alias Playground.Question
  alias Playground.Result
  import Ecto.Query

  def start(survey_id) do
    survey_id
    |> get_answers
    |> serialize_result
  end

  def start(survey_id, position) do
    survey_id
    |> get_answers(position)
    |> serialize_result
  end

  def get_answers(survey_id, position) do
    (from a in Answer,
      join: q in assoc(a, :question),
      join: m in assoc(q, :meta_question),
      where: q.survey_id == ^survey_id,
      where: q.position == ^position,
      preload: [question: {q, meta_question: m}])
      |> Repo.all()
  end

  def get_answers(survey_id) do
    (from a in Answer,
      join: q in assoc(a, :question),
      join: m in assoc(q, :meta_question),
      where: q.survey_id == ^survey_id,
      preload: [question: {q, meta_question: m}])
      |> Repo.all()
      #select: {a.answers, a.question_id, q.meta_question_id, m.type} 
  end

  def get_result(survey_id, position) do
    (from r in Result,
      join: q in assoc(r, :question),
      where: q.survey_id == ^survey_id,
      where: q.position == ^position,
      preload: [question: q])
      |> Repo.one()
  end

  def get_result(survey_id) do
    (from r in Result,
      join: q in assoc(r, :question),
      where: q.survey_id == ^survey_id,
      preload: [question: q])
      |> Repo.all()
  end

  def serialize_result(answers) do
    for ans <- answers do
      %{question_id: ans.question_id, result: ans.answers, type: ans.question.meta_question.type}
      |> get_result_changes()
    end
  end

  def get_result_changes(%{question_id: qid, result: res, type: type}) do
    case String.to_atom(type) do
      :fill ->
        if res["ansers"] != nil do
          %{question_id: qid, result: %{not_null: 1}, total: 1}
        else 
          %{question_id: qid, result: %{not_null: 0}, total: 1}
        end

      :select ->
        change = res 
                |> Enum.map(fn {k, v} -> {k, transfer_boolean(v)} end)

        %{question_id: qid, result: change, total: 1}

      _ ->
        %{question_id: qid, result: %{}, total: 0}
      
    end
  end

  defp transfer_boolean(b) when b == true, do: 1
  defp transfer_boolean(b), do: 0
end
