defmodule Playground.V1.ResultView do
  use Playground.Web, :view

  def render("index.json", %{data: res, total: total}) do
    render_many(res, __MODULE__, "results.json", as: :data, total: total)
  end

  def render("show.json", %{data: res, total: total}) do
    render_one(res, __MODULE__, "results.json", as: :data, total: total)
  end
  
  def render("results.json", %{data: res, total: total}) do
    %{survey_id: res.question.survey_id,
      position: res.question.position,
      results: render_many(res.result, __MODULE__, "options.json", as: :data, total: total)
    }
  end

  def render("options.json", %{data: res, total: total}) do
    
   [res]
   |> Enum.into(%{})
   |> set_result(total)
  end

  defp get_percent(left, right, precision) do
    Float.round(left*100/right, precision)
  end

  defp set_result(data, total) do
    data
    |> Enum.map(fn {k, v} -> {k <> "_percent", get_percent(v, total, 2)} end)
    |> List.flatten(Map.to_list(data))
    |> Map.new
  end

end
