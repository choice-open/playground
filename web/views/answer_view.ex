defmodule Playground.AnswerView do
  use Playground.Web, :view
  
  def render("show.json", %{data: answer}) do
  end

  def render("index.json", %{data: answer}) do
    %{
      php_count: answer.php_count,
      php_percent: get_percent(answer.php_count,answer.total_count,2),
      ruby_count: answer.ruby_count,
      ruby_percent: get_percent(answer.ruby_count,answer.total_count,2),
      elixir_count: answer.elixir_count,
      elixir_percent: get_percent(answer.elixir_count,answer.total_count,2),
      javascript_count: answer.javascript_count,
      javascript_percent: get_percent(answer.javascript_count,answer.total_count,2),
      not_null_count: answer.not_null_count,
      not_null_percent: get_percent(answer.not_null_count,answer.total_count,2),
    }
  end

  defp get_percent(left, right, precision) do
    Float.round(left*100/right,precision)
  end
end


