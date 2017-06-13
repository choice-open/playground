defmodule Playground.Web.SurveyControllerTest do
  use Playground.Web.ConnCase

  alias Playground.PSQ
  alias Playground.PSQ.Survey

  @create_attrs %{title: "some title"}
  @update_attrs %{title: "some updated title"}
  @invalid_attrs %{title: nil}

  def fixture(:survey) do
    {:ok, survey} = PSQ.create_survey(@create_attrs)
    survey
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, survey_path(conn, :index)
    assert json_response(conn, 200) == []
  end

  test "creates survey and renders survey when data is valid", %{conn: conn} do
    conn = post conn, survey_path(conn, :create), survey: @create_attrs
    assert %{"id" => id} = json_response(conn, 201)

    conn = get conn, survey_path(conn, :show, id)
    assert json_response(conn, 200) == %{
      "id" => id,
      "title" => "some title"}
  end

  test "does not create survey and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, survey_path(conn, :create), survey: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates chosen survey and renders survey when data is valid", %{conn: conn} do
    %Survey{id: id} = survey = fixture(:survey)
    conn = put conn, survey_path(conn, :update, survey), survey: @update_attrs
    assert %{"id" => ^id} = json_response(conn, 200)

    conn = get conn, survey_path(conn, :show, id)
    assert json_response(conn, 200) == %{
      "id" => id,
      "title" => "some updated title"}
  end

  test "does not update chosen survey and renders errors when data is invalid", %{conn: conn} do
    survey = fixture(:survey)
    conn = put conn, survey_path(conn, :update, survey), survey: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen survey", %{conn: conn} do
    survey = fixture(:survey)
    conn = delete conn, survey_path(conn, :delete, survey)
    assert response(conn, 204)
    assert_error_sent 404, fn ->
      get conn, survey_path(conn, :show, survey)
    end
  end
end
