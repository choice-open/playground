defmodule Playground.Web.V1.SurveyView do
  use Playground.Web, :view

  def render("show.json", %{resp: _resp}) do
    demo()
  end

  def render("stats.json", %{answers: answers, id: id}) do
    {fills, selects} = split_answers(answers)
    fills = stats(fills, :fill)
    selects = stats(selects, :select)

    %{
      id: id,
      fill_questions: fills,
      select_questions: selects,
    }
  end

  def stats(selects, :select) do
    selects
    |> group_by_question_id()
    |> Enum.map(fn {question_id, answers} ->
      total_options = length(answers)
      options =
        answers
        |> Enum.group_by(& &1.option_id)
        |> Enum.map(fn {option_id, option_answers} ->
          selected_count =
            option_answers
            |> Enum.filter(& &1.selected)
            |> length()

          percentage = percentage(selected_count, total_options)
          %{
            option_id: option_id,
            selected_count: selected_count,
            percentage: percentage,
          }
        end)
      %{
        question_id: question_id,
        options: options,
      }
    end)
  end


  def stats(fills, :fill) do
    fills
    |> group_by_question_id()
    |> Enum.map(fn {question_id, answers} ->
      none_empty =
        answers
        |> Enum.reject(& is_nil(&1.content))
        |> length()
      total = length(answers)
      percentage = percentage(none_empty, total)
      %{
        question_id: question_id,
        none_empty: none_empty,
        total: total,
        percentage: percentage,
      }
    end)
  end

  def group_by_question_id(answers) do
    answers
    |> List.flatten()
    |> Enum.group_by(& &1.question_id)
  end

  def split_answers(answers) do
    answers
    |> Enum.reduce({[], []}, fn answer, {fills, selects} ->
      {
        [answer.fill_answer_details   | fills],
        [answer.select_answer_details | selects]
      }
    end)
  end

  defp percentage(_num, 0), do: "0.00"
  defp percentage(num, den) do
    num
    |> Kernel./(den)
    |> Float.floor(4)
    |> Kernel.*(100)
    |> to_string()
  end

  defp demo() do
    %{
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
          required: false,
        }
      ]
    }
  end
end
