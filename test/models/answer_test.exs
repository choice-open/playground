defmodule Playground.AnswerTest do
  use Playground.ModelCase

  alias Playground.Answer

  @valid_attrs %{answer1: [true, true, true, false], answer2: "whatever"}
  @invalid_attrs %{answer1: [true, false, false, false, true], answer2: ""}

  test "changeset with valid attributes" do
    changeset = Answer.changeset(%Answer{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Answer.changeset(%Answer{}, @invalid_attrs)
    refute changeset.valid?
  end
end

