defmodule SimpleCform.SurveysTest do
  use SimpleCform.DataCase

  alias SimpleCform.Surveys

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
end
