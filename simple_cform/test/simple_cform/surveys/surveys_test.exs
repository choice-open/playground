defmodule SimpleCform.SurveysTest do
  use SimpleCform.DataCase

  alias SimpleCform.Surveys

  describe "get_survey!/1" do
    test "returns expected results for id = 1" do
      expected_survey = %{
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

      assert Surveys.get_survey!(1) == expected_survey
    end

    test "returns empty survey for id != 1" do
      expected_survey = %{id: 2, questions: []}
      assert Surveys.get_survey!(2) == expected_survey
    end
  end

  def select_question_fixture(id: id), do: select_question_fixture(id: id, required: true)

  def select_question_fixture(id: id, required: required) do
    %{
      id: id,
      type: "select",
      title: "Fake Select Question Title",
      required: required,
      options: [
        %{
          id: 1,
          content: "Fake Content"
        }
      ]
    }
  end

  def fill_question_fixture(id: id), do: fill_question_fixture(id: id, required: true)

  def fill_question_fixture(id: id, required: required) do
    %{
      id: id,
      type: "fill",
      title: "Fake Fill Question Title",
      required: required
    }
  end

  describe "create_response/2" do
    alias SimpleCform.Surveys.SelectAnswer
    alias SimpleCform.Surveys.FillAnswer

    def survey_fixture(questions: questions), do: survey_fixture(id: 1, questions: questions)

    def survey_fixture(id: id, questions: questions) do
      %{
        id: id,
        title: "Fake Survey Title",
        questions: questions
      }
    end

    test "sets survey_id in response correctly" do
      survey = survey_fixture(id: 1, questions: [])

      {:ok, %{survey_id: survey_id, answers: []}} = Surveys.create_response(survey, [])

      assert survey_id == 1
    end

    test "creates a select_answer for select_quostion" do
      select_question = select_question_fixture(id: 1)
      survey = survey_fixture(questions: [select_question])

      {:ok, %{answers: [%SelectAnswer{} = select_answer]}} =
        Surveys.create_response(survey, [%{question_id: 1, selected_options: [1]}])

      assert select_answer.question_id == 1
      assert select_answer.selected_options == [1]
    end

    test "creates a fill_answer for fill_question" do
      fill_question = fill_question_fixture(id: 1)
      survey = survey_fixture(questions: [fill_question])

      {:ok, %{answers: [%FillAnswer{} = fill_answer]}} =
        Surveys.create_response(survey, [%{question_id: 1, content: "Test Content"}])

      assert fill_answer.question_id == 1
      assert fill_answer.content == "Test Content"
    end

    test "creates a select_answer and fill_answer at the same time" do
      select_question = select_question_fixture(id: 1)
      fill_question = fill_question_fixture(id: 2)
      survey = survey_fixture(questions: [select_question, fill_question])

      {:ok, %{answers: [%SelectAnswer{}, %FillAnswer{}]}} =
        Surveys.create_response(survey, [
          %{question_id: 1, selected_options: [1]},
          %{question_id: 2, content: "Test Content"}
        ])
    end

    test "with a required select question validates selected_options' length" do
      select_question = select_question_fixture(id: 1, required: true)
      survey = survey_fixture(id: 1, questions: [select_question])

      assert {:error, 1, changeset} =
               Surveys.create_response(survey, [%{question_id: 1, selected_options: []}])

      assert "should have at least 1 item(s)" in errors_on(changeset).selected_options
    end

    test "with a non-required select question does not validates selected_options" do
      select_question = select_question_fixture(id: 1, required: false)
      survey = survey_fixture(id: 1, questions: [select_question])

      assert {:ok, _answer} =
               Surveys.create_response(survey, [%{question_id: 1, selected_options: []}])
    end

    test "with a required fill question validates content cannot be empty" do
      fill_question = fill_question_fixture(id: 1, required: true)
      survey = survey_fixture(id: 1, questions: [fill_question])

      assert {:error, 1, changeset} =
               Surveys.create_response(survey, [%{question_id: 1, content: ""}])

      assert "can't be blank" in errors_on(changeset).content
    end

    test "with a required fill question validates content cannot be nil" do
      fill_question = fill_question_fixture(id: 1, required: true)
      survey = survey_fixture(id: 1, questions: [fill_question])

      assert {:error, 1, changeset} =
               Surveys.create_response(survey, [%{question_id: 1, content: nil}])

      assert "can't be blank" in errors_on(changeset).content
    end

    test "with a non-required fill question does not validate content is required" do
      fill_question = fill_question_fixture(id: 1, required: false)
      survey = survey_fixture(id: 1, questions: [fill_question])

      assert {:ok, _answer} = Surveys.create_response(survey, [%{question_id: 1, content: ""}])
    end
  end

  describe "select_answers" do
    alias SimpleCform.Surveys.SelectAnswer

    @valid_attrs %{question_id: 42, selected_options: []}
    @update_attrs %{question_id: 43, selected_options: []}
    @invalid_attrs %{question_id: nil, selected_options: nil}

    def select_answer_fixture(attrs \\ %{}) do
      {:ok, select_answer} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Surveys.create_select_answer()

      select_answer
    end

    test "list_select_answers/0 returns all select_answers" do
      select_answer = select_answer_fixture()
      assert Surveys.list_select_answers() == [select_answer]
    end

    test "get_select_answer!/1 returns the select_answer with given id" do
      select_answer = select_answer_fixture()
      assert Surveys.get_select_answer!(select_answer.id) == select_answer
    end

    test "create_select_answer/1 with valid data creates a select_answer" do
      assert {:ok, %SelectAnswer{} = select_answer} = Surveys.create_select_answer(@valid_attrs)
      assert select_answer.question_id == 42
      assert select_answer.selected_options == []
    end

    test "create_select_answer/1 can accept multiple selected_options" do
      multi_selects_attrs = %{question_id: 42, selected_options: [1, 2]}

      assert {:ok, %SelectAnswer{} = select_answer} =
               Surveys.create_select_answer(multi_selects_attrs)

      assert select_answer.question_id == 42
      assert select_answer.selected_options == [1, 2]
    end

    test "create_select_answer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Surveys.create_select_answer(@invalid_attrs)
    end

    test "update_select_answer/2 with valid data updates the select_answer" do
      select_answer = select_answer_fixture()
      assert {:ok, select_answer} = Surveys.update_select_answer(select_answer, @update_attrs)
      assert %SelectAnswer{} = select_answer
      assert select_answer.question_id == 43
      assert select_answer.selected_options == []
    end

    test "update_select_answer/2 with invalid data returns error changeset" do
      select_answer = select_answer_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Surveys.update_select_answer(select_answer, @invalid_attrs)

      assert select_answer == Surveys.get_select_answer!(select_answer.id)
    end

    test "delete_select_answer/1 deletes the select_answer" do
      select_answer = select_answer_fixture()
      assert {:ok, %SelectAnswer{}} = Surveys.delete_select_answer(select_answer)
      assert_raise Ecto.NoResultsError, fn -> Surveys.get_select_answer!(select_answer.id) end
    end

    test "change_select_answer/1 returns a select_answer changeset" do
      select_answer = select_answer_fixture()
      assert %Ecto.Changeset{} = Surveys.change_select_answer(select_answer)
    end
  end

  describe "fill_answers" do
    alias SimpleCform.Surveys.FillAnswer

    @valid_attrs %{content: "some content", question_id: 42}
    @update_attrs %{content: "some updated content", question_id: 43}
    @invalid_attrs %{content: nil, question_id: nil}

    def fill_answer_fixture(attrs \\ %{}) do
      {:ok, fill_answer} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Surveys.create_fill_answer()

      fill_answer
    end

    test "list_fill_answers/0 returns all fill_answers" do
      fill_answer = fill_answer_fixture()
      assert Surveys.list_fill_answers() == [fill_answer]
    end

    test "get_fill_answer!/1 returns the fill_answer with given id" do
      fill_answer = fill_answer_fixture()
      assert Surveys.get_fill_answer!(fill_answer.id) == fill_answer
    end

    test "create_fill_answer/1 with valid data creates a fill_answer" do
      assert {:ok, %FillAnswer{} = fill_answer} = Surveys.create_fill_answer(@valid_attrs)
      assert fill_answer.content == "some content"
      assert fill_answer.question_id == 42
    end

    test "create_fill_answer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Surveys.create_fill_answer(@invalid_attrs)
    end

    test "update_fill_answer/2 with valid data updates the fill_answer" do
      fill_answer = fill_answer_fixture()
      assert {:ok, fill_answer} = Surveys.update_fill_answer(fill_answer, @update_attrs)
      assert %FillAnswer{} = fill_answer
      assert fill_answer.content == "some updated content"
      assert fill_answer.question_id == 43
    end

    test "update_fill_answer/2 with invalid data returns error changeset" do
      fill_answer = fill_answer_fixture()
      assert {:error, %Ecto.Changeset{}} = Surveys.update_fill_answer(fill_answer, @invalid_attrs)
      assert fill_answer == Surveys.get_fill_answer!(fill_answer.id)
    end

    test "delete_fill_answer/1 deletes the fill_answer" do
      fill_answer = fill_answer_fixture()
      assert {:ok, %FillAnswer{}} = Surveys.delete_fill_answer(fill_answer)
      assert_raise Ecto.NoResultsError, fn -> Surveys.get_fill_answer!(fill_answer.id) end
    end

    test "change_fill_answer/1 returns a fill_answer changeset" do
      fill_answer = fill_answer_fixture()
      assert %Ecto.Changeset{} = Surveys.change_fill_answer(fill_answer)
    end
  end
end
