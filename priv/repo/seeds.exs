# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
alias Playground.Repo
#
#     Playground.Repo.insert!(%Playground.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Playground.Survey
alias Playground.MetaQuestion
alias Playground.Question

Repo.delete_all(Survey)
Repo.delete_all(MetaQuestion)
Repo.delete_all(Question)

survey = Repo.insert! %Survey{
  title: "程序猿信仰测试" 
}

q1 = Repo.insert! %MetaQuestion{
  title: "请选择你最喜欢的语言",
  type: "select",
  required: true,
  options: ["PHP", "Ruby", "Elixir", "JavaScript"]
}
q2 = Repo.insert! %MetaQuestion{
  title: "请填写你喜欢它的原因",
  type: "fill",
  required: false,
  options: []
}

Repo.insert! %Question{
  position: 1,
  meta_question_id: q1.id,
  survey_id: survey.id
}
Repo.insert! %Question{
  position: 2,
  meta_question_id: q2.id,
  survey_id: survey.id
}
