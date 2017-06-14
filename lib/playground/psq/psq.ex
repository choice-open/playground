defmodule Playground.PSQ do

  import Ecto.Query, warn: false
  alias Playground.Repo

  alias Playground.PSQ.Survey
  alias Playground.PSQ.Option
  alias Playground.PSQ.Question
  alias Playground.PSQ.Answer

  def list_surveys do
    Repo.all(Survey)
  end

  def get_survey!(id), do: Repo.get!(Survey, id)

  def create_survey(attrs \\ %{}) do
    %Survey{}
    |> Survey.changeset(attrs)
    |> Repo.insert()
  end

  def update_survey(%Survey{} = survey, attrs) do
    survey
    |> Survey.changeset(attrs)
    |> Repo.update()
  end

  def delete_survey(%Survey{} = survey) do
    from(q in Question, where: q.survey_id == ^survey.id)
    |> Repo.all()
    |> Enum.map(&delete_question/1)
    Repo.delete(survey)
  end

  def change_survey(%Survey{} = survey) do
    Survey.changeset(survey, %{})
  end


  # PSQ.Question


  def list_questions(survey_id) do
    (from q in Question, where: q.survey_id == ^survey_id)
    |> Repo.all()
  end

  def get_question!(id, survey_id) do
    (from q in Question, where: q.id == ^id and q.survey_id == ^survey_id)
    |> Repo.one!()
  end

  def create_question(%{"type" => "fill"} = attrs) do
    %Question{}
    |> Question.changeset(attrs)
    |> Repo.insert()
  end

  def create_question(%{"type" => "select", "options" => options} = attrs) do
    question =
      %Question{}
      |> Question.changeset(attrs)
      |> Repo.insert!()

    options
    |> Enum.each(fn op ->
      attr = %{
        question_id: question.id,
        content: op,
        count: 0,
      }
      create_option(attr)
    end)

    {:ok, question}
  end

  def create_question(attrs) do
    {:error, %Question{} |> Question.changeset(attrs)}
  end


  def delete_question(%Question{} = question) do
    (from op in Option, where: op.question_id == ^question.id)
    |> Repo.delete_all()
    Repo.delete(question)
  end



  def list_options(question_id) do
    (from op in Option, where: op.question_id == ^question_id)
    |> Repo.all()
  end

  def get_option!(id, question_id) do
    (from op in Option, where: op.id == ^id and op.question_id == ^question_id)
    |> Repo.one!()
  end

  def create_option(attrs \\ %{}) do
    %Option{}
    |> Option.changeset(attrs)
    |> Repo.insert()
  end



  def list_answers(question_id) do
    (from ans in Answer, where: ans.question_id == ^question_id)
    |> Repo.all()
  end

  def create_answer(%{"question_id" => question_id, "survey_id" => survey_id} = attrs) do
    question = get_question!(question_id, survey_id)
    case question.type do
      "select" ->
        update_options(question.id, attrs["options_id"])
        {:ok, %Answer{}}
      "fill" ->
        attrs = %{attrs | "content" => attrs["content"] |> String.trim()}
        %Answer{}
        |> Answer.changeset(attrs)
        |> Repo.insert()
      _ ->
        {:error, %Answer{} |> Answer.changeset(attrs)}
    end
  end

  def update_options(question_id, options_id) do
    options_id
    |> Enum.each(fn option_id ->
      option = get_option!(option_id, question_id)
      option = Ecto.Changeset.change option, count: option.count + 1
      {:ok, _} = Repo.update(option)
    end)
  end

end
