defmodule Playground.Web.QuestionControllerTest do
  use Playground.Web.ConnCase

  alias Playground.PSQ
  alias Playground.PSQ.Question

  @create_attrs %{"required" => true, "survey_id" => 42, "title" => "some title", type: "select"}
  @invalid_attrs %{"required" => nil, "survey_id" => 66, "title" => nil, type: "fill"}

  def fixture(:question) do
    {:ok, question} = PSQ.create_question(@create_attrs)
    question
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  @tag :skip
  test "creates question and renders question when data is valid", %{conn: conn} do
    conn = post conn, survey_question_path(conn, :create, @create_attrs["survey_id"]), @create_attrs
    assert "ok" = json_response(conn, 201)

  end

  @tag :skip
  test "does not create question and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, survey_question_path(conn, :create, @invalid_attrs["survey_id"]), @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end


  @tag :skip
  test "deletes chosen question", %{conn: conn} do
    question = fixture(:question)
    conn = delete conn, survey_question_path(conn, :delete, question, @create_attrs["survey_id"])
    assert response(conn, 204)
  end
end
