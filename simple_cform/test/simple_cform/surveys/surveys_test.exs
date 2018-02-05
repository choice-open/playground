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
