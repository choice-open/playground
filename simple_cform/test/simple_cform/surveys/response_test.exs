defmodule SimpleCform.Surveys.ResponseTest do
  use SimpleCform.DataCase
  alias SimpleCform.Surveys.Response

  describe "changeset/2" do
    test "validates survey_id is required" do
      changeset = %Response{} |> Response.changeset(%{answers: []})

      assert "can't be blank" in errors_on(changeset)[:survey_id]
    end

    test "validates answers is required" do
      changeset = %Response{} |> Response.changeset(%{survey_id: 1, answers: nil})

      assert "can't be blank" in errors_on(changeset)[:answers]
    end

    test "validation failed if any question in the survey was not answered" do
      changeset = %Response{} |> Response.changeset(%{survey_id: 1, answers: []})

      assert "some questions were not answered" in errors_on(changeset).answers
    end

    test "validation passed if all questions in the survey were answered" do
      changeset =
        %Response{}
        |> Response.changeset(%{
          survey_id: 1,
          answers: [%{question_id: 1, selected_options: []}, %{question_id: 2, content: ""}]
        })

      assert changeset.valid?
    end
  end
end
