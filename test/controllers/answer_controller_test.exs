defmodule Playground.AnswerControllerTest do
  use Playground.ConnCase

  alias Playground.{Answer, Repo}

  test "index/2 respond the result" do
      answers = [Answer.changeset(%Answer{}, %{answer1: [true, true, true, true], answer2: "whatever"}), Answer.changeset(%Answer{}, %{answer1: [false, true, false, true], answer2: ""}), Answer.changeset(%Answer{}, %{answer1: [false,true,true,false], answer2: "whatever"})]

      Enum.each(answers, &Repo.insert!(&1))

      response = build_conn()
                 |> get(answer_path(build_conn(), :index))
                 |> json_response(200)

      expected = %{
        "ruby_percent" => 100.0,
        "ruby_count" => 3,
        "php_percent" => 33.33,
        "php_count" => 1,
        "elixir_percent" => 66.67,
        "elixir_count" => 2,
        "javascript_percent" => 66.67,
        "javascript_count" => 2,
        "not_null_percent" => 66.67, 
        "not_null_count" => 2 
      }

      assert response == expected
  end

  describe "create/2" do
    test "Creates, and responds with 201 with valid data" do
      answer = %{answer1: [true,true, false, false], answer2: "whatever"}
      response = build_conn()
                 |> post(answer_path(build_conn(), :create, answer))
      assert response.status == 201
    end

    test "Return an error with invalid data" do
      answer = %{answer1: [false, true,true, false, false], answer2: ""}
     response = build_conn()
                 |> post(answer_path(build_conn(), :create, answer))
      assert response.status == 400
    end
  end
end
