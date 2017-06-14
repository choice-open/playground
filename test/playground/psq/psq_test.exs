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

    @tag :skip
    test "list_surveys/0 returns all surveys" do
      survey = survey_fixture()
      assert PSQ.list_surveys() == [survey]
    end

    @tag :skip
    test "get_survey!/1 returns the survey with given id" do
      survey = survey_fixture()
      assert PSQ.get_survey!(survey.id) == survey
    end

    @tag :skip
    test "create_survey/1 with valid data creates a survey" do
      assert {:ok, %Survey{} = survey} = PSQ.create_survey(@valid_attrs)
      assert survey.title == "some title"
    end

    @tag :skip
    test "create_survey/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = PSQ.create_survey(@invalid_attrs)
    end

    @tag :skip
    test "update_survey/2 with valid data updates the survey" do
      survey = survey_fixture()
      assert {:ok, survey} = PSQ.update_survey(survey, @update_attrs)
      assert %Survey{} = survey
      assert survey.title == "some updated title"
    end

    @tag :skip
    test "update_survey/2 with invalid data returns error changeset" do
      survey = survey_fixture()
      assert {:error, %Ecto.Changeset{}} = PSQ.update_survey(survey, @invalid_attrs)
      assert survey == PSQ.get_survey!(survey.id)
    end

    @tag :skip
    test "delete_survey/1 deletes the survey" do
      survey = survey_fixture()
      assert {:ok, %Survey{}} = PSQ.delete_survey(survey)
      assert_raise Ecto.NoResultsError, fn -> PSQ.get_survey!(survey.id) end
    end

    @tag :skip
    test "change_survey/1 returns a survey changeset" do
      survey = survey_fixture()
      assert %Ecto.Changeset{} = PSQ.change_survey(survey)
    end
  end

  describe "questions" do
    alias Playground.PSQ.Question

    @valid_attrs %{"required" => true, "survey_id" => 42, "title" => "some title", "type" => "select"}
    @update_attrs %{"required" => false, "survey_id" => 43, "title" => "some updated title", "type" => "fill"}
    @invalid_attrs %{"required" => nil, "survey_id" => nil, "title" => nil, "type" => nil}

    def question_fixture(attrs \\ %{}) do
      {:ok, question} =
        attrs
        |> Enum.into(@valid_attrs)
        |> PSQ.create_question()

      question
    end

    @tag :skip
    test "list_questions/0 returns all questions" do
      question = question_fixture()
      assert PSQ.list_questions() == [question]
    end

    @tag :skip
    test "get_question!/1 returns the question with given id" do
      question = question_fixture()
      assert PSQ.get_question!(question.id) == question
    end

    @tag :skip
    test "create_question/1 with valid data creates a question" do
      assert {:ok, %Question{} = question} = PSQ.create_question(@valid_attrs)
      assert question.required == true
      assert question.survey_id == 42
      assert question.title == "some title"
      assert question.type == "some type"
    end

    @tag :skip
    test "create_question/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = PSQ.create_question(@invalid_attrs)
    end

    @tag :skip
    test "delete_question/1 deletes the question" do
      question = question_fixture()
      assert {:ok, %Question{}} = PSQ.delete_question(question)
      assert_raise Ecto.NoResultsError, fn -> PSQ.get_question!(question.id) end
    end
  end

  describe "options" do
    alias Playground.PSQ.Option

    @valid_attrs %{content: "some content", count: 42, question_id: 42}
    @update_attrs %{content: "some updated content", count: 43, question_id: 43}
    @invalid_attrs %{content: nil, count: nil, question_id: nil}

    @tag :skip
    def option_fixture(attrs \\ %{}) do
      {:ok, option} =
        attrs
        |> Enum.into(@valid_attrs)
        |> PSQ.create_option()

      option
    end

    @tag :skip
    test "list_options/0 returns all options" do
      option = option_fixture()
      assert PSQ.list_options() == [option]
    end

    @tag :skip
    test "get_option!/1 returns the option with given id" do
      option = option_fixture()
      assert PSQ.get_option!(option.id) == option
    end

    @tag :skip
    test "create_option/1 with valid data creates a option" do
      assert {:ok, %Option{} = option} = PSQ.create_option(@valid_attrs)
      assert option.content == "some content"
      assert option.count == 42
      assert option.question_id == 42
    end

    @tag :skip
    test "create_option/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = PSQ.create_option(@invalid_attrs)
    end

    @tag :skip
    test "delete_option/1 deletes the option" do
      option = option_fixture()
      assert {:ok, %Option{}} = PSQ.delete_option(option)
      assert_raise Ecto.NoResultsError, fn -> PSQ.get_option!(option.id) end
    end

  end
end
