defmodule Playground.PSQTest do
  use Playground.DataCase

  alias Playground.PSQ

  describe "surveys" do
    alias Playground.PSQ.Survey

    @valid_attrs %{title: "some title"}
    @update_attrs %{title: "some updated title"}
    @invalid_attrs %{title: nil}

    def survey_fixture(attrs \\ %{}) do
      {:ok, survey} =
        attrs
        |> Enum.into(@valid_attrs)
        |> PSQ.create_survey()

      survey
    end

    test "list_surveys/0 returns all surveys" do
      survey = survey_fixture()
      assert PSQ.list_surveys() == [survey]
    end

    test "get_survey!/1 returns the survey with given id" do
      survey = survey_fixture()
      assert PSQ.get_survey!(survey.id) == survey
    end

    test "create_survey/1 with valid data creates a survey" do
      assert {:ok, %Survey{} = survey} = PSQ.create_survey(@valid_attrs)
      assert survey.title == "some title"
    end

    test "create_survey/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = PSQ.create_survey(@invalid_attrs)
    end

    test "update_survey/2 with valid data updates the survey" do
      survey = survey_fixture()
      assert {:ok, survey} = PSQ.update_survey(survey, @update_attrs)
      assert %Survey{} = survey
      assert survey.title == "some updated title"
    end

    test "update_survey/2 with invalid data returns error changeset" do
      survey = survey_fixture()
      assert {:error, %Ecto.Changeset{}} = PSQ.update_survey(survey, @invalid_attrs)
      assert survey == PSQ.get_survey!(survey.id)
    end

    test "delete_survey/1 deletes the survey" do
      survey = survey_fixture()
      assert {:ok, %Survey{}} = PSQ.delete_survey(survey)
      assert_raise Ecto.NoResultsError, fn -> PSQ.get_survey!(survey.id) end
    end

    test "change_survey/1 returns a survey changeset" do
      survey = survey_fixture()
      assert %Ecto.Changeset{} = PSQ.change_survey(survey)
    end
  end

  describe "questions" do
    alias Playground.PSQ.Question

    @valid_attrs %{"required" => true, "survey_id" => 42, "title" => "some title", "type" => "fill"}
    @invalid_attrs %{"required" => nil, "survey_id" => nil, "title" => nil, "type" => nil}
    @select_question_attrs %{"required" => true, "survey_id" => 42, "title" => "some title", "type" => "select", "options" => ["AAA", "BBB", "CCC"]}

    def question_fixture(attrs \\ %{}) do
      {:ok, question} =
        attrs
        |> Enum.into(@valid_attrs)
        |> PSQ.create_question()

      question
    end

    test "list_questions/1 returns all questions" do
      question = question_fixture()
      assert PSQ.list_questions(@valid_attrs["survey_id"]) == [question]
    end

    test "get_question!/2 returns the question with given id" do
      question = question_fixture()
      assert PSQ.get_question!(question.id, @valid_attrs["survey_id"]) == question
    end

    test "create_question/1 create fill question with valid data creates a question" do
      assert {:ok, %Question{} = question} = PSQ.create_question(@valid_attrs)
      assert question.required == true
      assert question.survey_id == 42
      assert question.title == "some title"
      assert question.type == "fill"
    end

    test "create_question/1 create select question with valid data creates a question" do
      assert {:ok, %Question{} = question} = PSQ.create_question(@select_question_attrs)
      assert question.required == true
      assert question.survey_id == 42
      assert question.title == "some title"
      assert question.type == "select"

      options_num = length(PSQ.list_options(question.id))
      assert options_num == length(@select_question_attrs["options"])
    end

    test "create_question/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = PSQ.create_question(@invalid_attrs)
    end

    test "delete_question/1 deletes the question" do
      question = question_fixture()
      assert {:ok, %Question{}} = PSQ.delete_question(question)

      options_num = length(PSQ.list_options(question.id))
      assert options_num == 0
      assert_raise Ecto.NoResultsError, fn -> PSQ.get_question!(question.id, question.survey_id) end
    end
  end

  describe "options" do
    alias Playground.PSQ.Option

    @valid_attrs %{content: "some content", count: 42, question_id: 42}
    @invalid_attrs %{content: nil, count: nil, question_id: nil}

    def option_fixture(attrs \\ %{}) do
      {:ok, option} =
        attrs
        |> Enum.into(@valid_attrs)
        |> PSQ.create_option()

      option
    end

    test "list_options/1 returns all options" do
      option = option_fixture()
      assert PSQ.list_options(option.question_id) == [option]
    end

    test "get_option!/2 returns the option with given id" do
      option = option_fixture()
      assert PSQ.get_option!(option.id, option.question_id) == option
    end

    test "create_option/1 with valid data creates a option" do
      assert {:ok, %Option{} = option} = PSQ.create_option(@valid_attrs)
      assert option.content == "some content"
      assert option.count == 42
      assert option.question_id == 42
    end

    test "create_option/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = PSQ.create_option(@invalid_attrs)
    end

  end
end
