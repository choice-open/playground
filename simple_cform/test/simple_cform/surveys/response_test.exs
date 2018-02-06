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
  end
end
