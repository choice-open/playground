defmodule SimpleCform.SurveysTest do
  use SimpleCform.DataCase

  alias SimpleCform.Surveys

  describe "get_survey!/1" do
    test "returns expected results for id = 1" do
      expected_survey = %{
        id: 1,
        title: "程序员信仰测试",
        questions: [
          %{
            id: 1,
            type: "select",
            title: "请选择你最喜欢的语言",
            required: true,
            options: [
              %{
                id: 1,
                content: "PHP"
              },
              %{
                id: 2,
                content: "Ruby"
              },
              %{
                id: 3,
                content: "Elixir"
              },
              %{
                id: 4,
                content: "JavaScript"
              }
            ]
          },
          %{
            id: 2,
            type: "fill",
            title: "请填写你喜欢它的原因",
            required: false
          }
        ]
      }

      assert Surveys.get_survey!(1) == expected_survey
    end

    test "returns empty survey for id != 1" do
      expected_survey = %{id: 2, questions: []}
      assert Surveys.get_survey!(2) == expected_survey
    end
  end

  def select_question_fixture(id: id), do: select_question_fixture(id: id, required: true)

  def select_question_fixture(id: id, required: required) do
    %{
      id: id,
      type: "select",
      title: "Fake Select Question Title",
      required: required,
      options: [
        %{
          id: 1,
          content: "Fake Content"
        }
      ]
    }
  end

  def fill_question_fixture(id: id), do: fill_question_fixture(id: id, required: true)

  def fill_question_fixture(id: id, required: required) do
    %{
      id: id,
      type: "fill",
      title: "Fake Fill Question Title",
      required: required
    }
  end

  describe "create_response/2" do
    alias SimpleCform.Surveys.SelectAnswer
    alias SimpleCform.Surveys.FillAnswer

    def survey_fixture(questions: questions), do: survey_fixture(id: 1, questions: questions)

    def survey_fixture(id: id, questions: questions) do
      %{
        id: id,
        title: "Fake Survey Title",
        questions: questions
      }
    end

    test "creates a select_answer and fill_answer at the same time" do
      select_question = select_question_fixture(id: 1)
      fill_question = fill_question_fixture(id: 2)
      survey = survey_fixture(questions: [select_question, fill_question])

      {:ok, %{answers: [%SelectAnswer{}, %FillAnswer{}]}} =
        Surveys.create_response(survey, [
          %{question_id: 1, selected_options: [1]},
          %{question_id: 2, content: "Test Content"}
        ])
    end
  end
end
