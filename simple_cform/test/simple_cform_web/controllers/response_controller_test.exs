defmodule SimpleCformWeb.ResponseControllerTest do
  use SimpleCformWeb.ConnCase

  describe "POST /v1/responses" do
    test "returns 201 :created", %{conn: conn} do
      conn = post(conn, "/v1/responses", %{"survey_id" => 2, "answers" => []})
      assert conn.status == 201
    end

    test "renders response as JSON correctly", %{conn: conn} do
      conn =
        post(conn, "/v1/responses", %{
          "survey_id" => 1,
          "answers" => [
            %{"question_id" => 1, "selected_options" => [1]},
            %{"question_id" => 2, "content" => "Test Content"}
          ]
        })

      assert json_response(conn, :created) == %{
               "response" => %{
                 "survey_id" => 1,
                 "answers" => [
                   %{"question_id" => 1, "selected_options" => [1]},
                   %{"question_id" => 2, "content" => "Test Content"}
                 ]
               }
             }
    end

    test "renders correctly when content is null", %{conn: conn} do
      conn =
        post(conn, "/v1/responses", %{
          "survey_id" => 1,
          "answers" => [
            %{"question_id" => 1, "selected_options" => [1]},
            %{"question_id" => 2, "content" => nil}
          ]
        })

      assert json_response(conn, :created) == %{
               "response" => %{
                 "survey_id" => 1,
                 "answers" => [
                   %{"question_id" => 1, "selected_options" => [1]},
                   %{"question_id" => 2, "content" => nil}
                 ]
               }
             }
    end

    test "returns 400 :bad_request when a question is not answered", %{conn: conn} do
      conn =
        post(conn, "/v1/responses", %{
          "survey_id" => 1,
          "answers" => [
            %{"question_id" => 1, "selected_options" => [1]}
          ]
        })

      assert conn.status == 400
    end

    test "renders correctly when a question is not answered", %{conn: conn} do
      conn =
        post(conn, "/v1/responses", %{
          "survey_id" => 1,
          "answers" => [
            %{"question_id" => 1, "selected_options" => [1]}
          ]
        })

      assert json_response(conn, :bad_request) == %{
               "error" => %{
                 "unanswered_questions_ids" => [2],
                 "reason" => %{"answers" => "Some questions were not answered."}
               }
             }
    end

    test "returns 400 :bad_request when response creation failed", %{conn: conn} do
      conn =
        post(conn, "/v1/responses", %{
          "survey_id" => 1,
          "answers" => [
            %{"question_id" => 1, "selected_options" => nil},
            %{"question_id" => 2, "content" => "Test Content"}
          ]
        })

      assert conn.status == 400
    end

    test "renders correctly when selected_options is empty", %{conn: conn} do
      conn =
        post(conn, "/v1/responses", %{
          "survey_id" => 1,
          "answers" => [
            %{"question_id" => 1, "selected_options" => []},
            %{"question_id" => 2, "content" => "Test Content"}
          ]
        })

      assert json_response(conn, :bad_request) == %{
               "error" => %{
                 "failed_question_id" => 1,
                 "reason" => %{
                   "selected_options" => "should have at least 1 item(s)"
                 }
               }
             }
    end
  end
end
