defmodule SimpleCformWeb.StatisticTest do
  use SimpleCformWeb.ConnCase

  describe "collect responses and get statistics" do
    test "shows statistic info for select question correctly", %{conn: conn} do
      # NOTE: select question setup is skipped since get_survey! is hard-coded
      conn =
        conn
        |> submit_response([1], "")
        |> submit_response([2], "not empty")
        |> fetch_statistics()

      body = json_response(conn, :ok)

      assert %{
               "statistics" => [
                 %{
                   "options" => [
                     %{"id" => 1, "percentage" => 50.0, "selected" => 1},
                     %{"id" => 2, "percentage" => 50.0, "selected" => 1},
                     %{"id" => 3, "percentage" => 0.0, "selected" => 0},
                     %{"id" => 4, "percentage" => 0.0, "selected" => 0}
                   ],
                   "question_id" => 1
                 },
                 %{
                   "content" => %{"non_empty" => 1, "percentage" => 50.0},
                   "question_id" => 2
                 }
               ]
             } = body
    end
  end

  def submit_response(conn, options, content) do
    conn
    |> post(
      "/v1/responses",
      survey_id: 1,
      answers: [
        %{"question_id" => 1, "selected_options" => options},
        %{"question_id" => 2, "content" => content}
      ]
    )
  end

  def fetch_statistics(conn) do
    conn
    |> get("/v1/surveys/1/statistics", survey_id: 1)
  end
end
