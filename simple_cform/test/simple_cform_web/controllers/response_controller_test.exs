defmodule SimpleCformWeb.ResponseControllerTest do
  use SimpleCformWeb.ConnCase

  describe "POST /v1/responses" do
    test "returns 201 :created", %{conn: conn} do
      conn = post(conn, "/v1/responses", survey_id: 1, answers: [])
      assert conn.status == 201
    end

    test "renders response as JSON correctly", %{conn: conn} do
      conn =
        post(
          conn,
          "/v1/responses",
          survey_id: 1,
          answers: [
            %{"question_id" => 1, "selected_options" => [1]},
            %{"question_id" => 2, "content" => "Test Content"}
          ]
        )

      assert json_response(conn, :created) == %{
               # "response" =>
               "survey_id" => 1,
               "answers" => [
                 %{"question_id" => 1, "selected_options" => [1]},
                 %{"question_id" => 2, "content" => "Test Content"}
               ]
             }
    end
  end
end
