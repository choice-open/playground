defmodule Playground.Web.QuestionControllerTest do
  use Playground.Web.ConnCase

  alias Playground.PSQ

  import Ecto.Query, warn: false

  @create_attrs %{"required" => true, "survey_id" => 42, "title" => "some title", "type" => "fill"}
  @select_question_attrs %{"required" => true, "survey_id" => 42, "title" => "some title", "type" => "select", "options" => ["AAA", "BBB", "CCC"]}
  @invalid_attrs %{"required" => nil, "survey_id" => 66, "title" => nil, "type" => "fill"}

  def fixture(:question) do
    {:ok, question} = PSQ.create_question(@create_attrs)
    question
  end

  def fixture(:select_question) do
    {:ok, question} = PSQ.create_question(@select_question_attrs)
    question
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "creates question when data is valid", %{conn: conn} do
    conn = post conn, survey_question_path(conn, :create, @create_attrs["survey_id"]), @create_attrs
    assert %{"id" => _} = json_response(conn, 201)
  end

  test "creates select question when data is valid", %{conn: conn} do
    conn = post conn, survey_question_path(conn, :create, @create_attrs["survey_id"]), @select_question_attrs
    assert %{"id" => id} = json_response(conn, 201)
    options_num = length(PSQ.list_options(id))
    assert options_num == length(@select_question_attrs["options"])
  end

  test "does not create question and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, survey_question_path(conn, :create, @invalid_attrs["survey_id"]), @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end


  test "deletes fill question", %{conn: conn} do
    question = fixture(:question)
    conn = delete conn, survey_question_path(conn, :delete, @create_attrs["survey_id"], question)
    assert response(conn, 204)
  end

  test "delete select question", %{conn: conn} do
    question = fixture(:select_question)
    options_num = length(PSQ.list_options(question.id))
    assert options_num == length(@select_question_attrs["options"])

    conn = delete conn, survey_question_path(conn, :delete, @create_attrs["survey_id"], question)
    assert response(conn, 204)

    options_num = length(PSQ.list_options(question.id))
    assert options_num == 0
  end
end
