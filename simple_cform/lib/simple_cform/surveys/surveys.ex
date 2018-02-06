defmodule SimpleCform.Surveys do
  @moduledoc """
  The Surveys context.
  """

  import Ecto.Query, warn: false
  import Ecto.Changeset
  alias Ecto.Multi
  alias SimpleCform.Repo

  alias SimpleCform.Surveys.Response
  alias SimpleCform.Surveys.SelectAnswer
  alias SimpleCform.Surveys.FillAnswer

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
            |> Map.delete(:validate_all_questions_were_answered)
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

  def build_response_multi(survey, answers_attrs) do
    answers_attrs
    |> Enum.reduce(Multi.new(), fn attr, multi ->
      # HACK: support both types of question_id from controller and test
      question_id = attr["question_id"] || attr[:question_id]
      question = get_question(question_id, survey)
      create_answer(multi, question, attr)
    end)
    |> Multi.run(:validate_all_questions_were_answered, fn _ ->
      # HACK: this should be a validation step in Response Changeset, but we don't
      # have Response module yet, so I put it here for some convenience (it's
      # easier to raise error here)
      validate_all_questions_have_answer(survey, answers_attrs)
    end)
  end

  defp validate_all_questions_have_answer(survey, answers_attrs) do
    asked_questions_ids = survey.questions |> Enum.map(& &1.id) |> Enum.sort()

    answered_questions_ids =
      answers_attrs |> Enum.map(&(&1["question_id"] || &1[:question_id])) |> Enum.sort()

    unanswered_questions_ids =
      asked_questions_ids
      |> Enum.filter(&(&1 not in answered_questions_ids))

    if Enum.empty?(unanswered_questions_ids) do
      {:ok, nil}
    else
      {:error, unanswered_questions_ids}
    end
  end

  defp get_question(id, survey) do
    survey.questions
    |> Enum.find(fn question -> question.id == id end)
  end

  @doc false
  defp create_answer(multi, %{id: question_id, type: "select", required: true}, attrs) do
    changeset =
      %SelectAnswer{}
      |> SelectAnswer.changeset(attrs)
      |> validate_length(:selected_options, min: 1)

    multi
    |> Multi.insert(question_id, changeset)
  end

  defp create_answer(multi, %{id: question_id, type: "select", required: false}, attrs) do
    changeset =
      %SelectAnswer{}
      |> SelectAnswer.changeset(attrs)

    multi
    |> Multi.insert(question_id, changeset)
  end

  defp create_answer(multi, %{id: question_id, type: "fill", required: true}, attrs) do
    changeset =
      %FillAnswer{}
      |> FillAnswer.changeset(attrs)
      |> validate_required(:content)

    multi
    |> Multi.insert(question_id, changeset)
  end

  defp create_answer(multi, %{id: question_id, type: "fill", required: false}, attrs) do
    changeset =
      %FillAnswer{}
      |> FillAnswer.changeset(attrs)

    multi
    |> Multi.insert(question_id, changeset)
  end

  @doc """
  Returns the list of select_answers.

  ## Examples

      iex> list_select_answers()
      [%SelectAnswer{}, ...]

  """
  def list_select_answers do
    Repo.all(SelectAnswer)
  end

  @doc """
  Gets a single select_answer.

  Raises `Ecto.NoResultsError` if the Select answer does not exist.

  ## Examples

      iex> get_select_answer!(123)
      %SelectAnswer{}

      iex> get_select_answer!(456)
      ** (Ecto.NoResultsError)

  """
  def get_select_answer!(id), do: Repo.get!(SelectAnswer, id)

  @doc """
  Creates a select_answer.

  ## Examples

      iex> create_select_answer(%{field: value})
      {:ok, %SelectAnswer{}}

      iex> create_select_answer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_select_answer(attrs \\ %{}) do
    %SelectAnswer{}
    |> SelectAnswer.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a select_answer.

  ## Examples

      iex> update_select_answer(select_answer, %{field: new_value})
      {:ok, %SelectAnswer{}}

      iex> update_select_answer(select_answer, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_select_answer(%SelectAnswer{} = select_answer, attrs) do
    select_answer
    |> SelectAnswer.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a SelectAnswer.

  ## Examples

      iex> delete_select_answer(select_answer)
      {:ok, %SelectAnswer{}}

      iex> delete_select_answer(select_answer)
      {:error, %Ecto.Changeset{}}

  """
  def delete_select_answer(%SelectAnswer{} = select_answer) do
    Repo.delete(select_answer)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking select_answer changes.

  ## Examples

      iex> change_select_answer(select_answer)
      %Ecto.Changeset{source: %SelectAnswer{}}

  """
  def change_select_answer(%SelectAnswer{} = select_answer) do
    SelectAnswer.changeset(select_answer, %{})
  end

  @doc """
  Returns the list of fill_answers.

  ## Examples

      iex> list_fill_answers()
      [%FillAnswer{}, ...]

  """
  def list_fill_answers do
    Repo.all(FillAnswer)
  end

  @doc """
  Gets a single fill_answer.

  Raises `Ecto.NoResultsError` if the Fill answer does not exist.

  ## Examples

      iex> get_fill_answer!(123)
      %FillAnswer{}

      iex> get_fill_answer!(456)
      ** (Ecto.NoResultsError)

  """
  def get_fill_answer!(id), do: Repo.get!(FillAnswer, id)

  @doc """
  Creates a fill_answer.

  ## Examples

      iex> create_fill_answer(%{field: value})
      {:ok, %FillAnswer{}}

      iex> create_fill_answer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_fill_answer(attrs \\ %{}) do
    %FillAnswer{}
    |> FillAnswer.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a fill_answer.

  ## Examples

      iex> update_fill_answer(fill_answer, %{field: new_value})
      {:ok, %FillAnswer{}}

      iex> update_fill_answer(fill_answer, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_fill_answer(%FillAnswer{} = fill_answer, attrs) do
    fill_answer
    |> FillAnswer.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a FillAnswer.

  ## Examples

      iex> delete_fill_answer(fill_answer)
      {:ok, %FillAnswer{}}

      iex> delete_fill_answer(fill_answer)
      {:error, %Ecto.Changeset{}}

  """
  def delete_fill_answer(%FillAnswer{} = fill_answer) do
    Repo.delete(fill_answer)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking fill_answer changes.

  ## Examples

      iex> change_fill_answer(fill_answer)
      %Ecto.Changeset{source: %FillAnswer{}}

  """
  def change_fill_answer(%FillAnswer{} = fill_answer) do
    FillAnswer.changeset(fill_answer, %{})
  end
end
