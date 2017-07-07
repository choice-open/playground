defmodule Playground.HelpFunc do
  alias Playground.{Repo, Answer, Result}
  import Ecto.Query

  def start(survey_id) do
    answers = get_answers(survey_id)
    answers
    |> serialize_result
    |> set_result(answers)
  end

  defp get_answers(survey_id) do
    (from a in Answer,
      join: q in assoc(a, :question),
      join: m in assoc(q, :meta_question),
      where: q.survey_id == ^survey_id,
      where: a.counted == false,
      preload: [question: {q, meta_question: m}])
      |> Repo.all()
  end

  def get_result(survey_id, position) do
    (from r in Result,
      join: q in assoc(r, :question),
      where: q.survey_id == ^survey_id,
      where: q.position == ^position,
      preload: [question: q])
      |> Repo.one
  end

  def get_result_query(survey_id) do
    from r in Result,
      join: q in assoc(r, :question),
      where: q.survey_id == ^survey_id,
      preload: [question: q]
  end
  
  def get_results(survey_id) do
    get_result_query(survey_id)
    |> Repo.all
  end

  def delete_result(survey_id, position) do
    get_result(survey_id, position)
    |> Repo.delete
  end

  def delete_result(survey_id) do
    (from r in Result,
      join: q in assoc(r, :question),
      #preload: [question: q]),
      where: q.survey_id == ^survey_id)
    |> Repo.delete_all
  end


  defp set_result(changes, answers) do
    Repo.transaction(fn ->
        for change <- changes, ans <- answers do
          case Repo.get_by(Result, question_id: change.question_id) do
        nil -> 
          struct(%Result{}, change)
          |> Result.changeset
          |> Repo.insert
          set_counted(ans)
            
        res -> 
          new_result = change.result
                      |> Map.merge(res.result, fn _k, v1, v2 -> v1 + v2 end)
          update_result = Result.changeset(res, %{result: new_result, total: res.total + change.total})
          #好像是乐观锁根据changeset创建时间决定，所以这里我重建了changeset，不知道对不对
            try do
              Repo.update(update_result)
              set_counted(ans)
            rescue
              Ecto.StaleEntryError -> 
                Repo.update(Result.changeset(res, %{result: new_result, total: res.total + change.total}))
                set_counted(ans)
            end
        end
      end
    end)
    #|> Keyword.keys
    #|> Enum.member?(:error)
  end

  defp set_counted(ans) do
    answer = Ecto.Changeset.change ans, counted: true
    try do
      Repo.update(answer)
    rescue
      Ecto.StaleEntryError ->
        Repo.update(Ecto.Changeset.change ans, counted: true)
    end
  end

  defp serialize_result(answers) do
    for ans <- answers do
      %{question_id: ans.question_id, result: ans.answers, type: ans.question.meta_question.type}
      |> get_result_changes()
    end
  end

  defp get_result_changes(%{question_id: qid, result: res, type: type}) do
    case String.to_atom(type) do
      :fill ->
        if res["answers"] == "" do
          %{question_id: qid, result: %{"not_null" => 0}, total: 1}
        else 
          %{question_id: qid, result: %{"not_null" => 1}, total: 1}
        end

      :select ->
        change = res 
                |> Enum.map(fn {k, v} -> {k, transfer_boolean(v)} end)
                |> Map.new

        %{question_id: qid, result: change, total: 1}

      _ ->
        %{question_id: qid, result: %{}, total: 0}
      
    end
  end

  defp transfer_boolean(b) when b == true, do: 1
  defp transfer_boolean(_b), do: 0
end
