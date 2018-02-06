defmodule SimpleCform.Surveys.Response do
  use Ecto.Schema
  import Ecto.Changeset
  alias SimpleCform.Surveys
  alias SimpleCform.Surveys.Response

  embedded_schema do
    field(:survey_id, :integer)
    field(:answers, {:array, :map})
  end

  def changeset(%Response{} = response, attrs) do
    response
    |> cast(attrs, [:survey_id, :answers])
    |> validate_required([:survey_id, :answers])
    |> validate_all_questions_were_answered()
  end
end
