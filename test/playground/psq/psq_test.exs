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

    # test "delete_survey/1 deletes the survey" do
    #   survey = survey_fixture()
    #   assert {:ok, %Survey{}} = PSQ.delete_survey(survey)
    #   assert_raise Ecto.NoResultsError, fn -> PSQ.get_survey!(survey.id) end
    # end

    test "change_survey/1 returns a survey changeset" do
      survey = survey_fixture()
      assert %Ecto.Changeset{} = PSQ.change_survey(survey)
    end
  end
end
