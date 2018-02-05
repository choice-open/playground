defmodule SimpleCformWeb.ResponseView do
  use SimpleCformWeb, :view

  def render("create.json", _assigns) do
    %{
      answers: [
        %{question_id: 1, selected_options: [1]},
        %{question_id: 2, content: "Test Content"}
      ]
    }
  end
end
