# survey show
`curl "http://localhost:4000/api/v1/surveys/3"`

# create answer
```
curl -X "POST" "http://localhost:4000/api/v1/surveys/1/answers" \
     -H "Content-Type: application/json; charset=utf-8" \
     -d $'{
  "answers": [
    {
      "options": [
        {
          "id": "1",
          "content": "PHP",
          "selected": false
        },
        {
          "id": "2",
          "content": "Ruby",
          "selected": false
        },
        {
          "id": "3",
          "content": "Elixir",
          "selected": true
        },
        {
          "id": "4",
          "content": "JavaScript",
          "selected": true
        }
      ],
      "question_id": "1",
      "question_type": "select"
    },
    {
      "content": "       ",
      "question_id": "2",
      "question_type": "fill"
    }
  ]
}'
```

# show answer
`curl "http://localhost:4000/api/v1/surveys/1/answers/1"`

## show answer return

```json
{
  "id": 1,
  "survey_id": 1,
  "select_question_answer": [
    {
      "question_type": "select",
      "question_id": 1,
      "options": [
        {
          "selected": false,
          "option_id": 1,
          "content": "PHP"
        },
        {
          "selected": true,
          "option_id": 2,
          "content": "Ruby"
        },
        {
          "selected": true,
          "option_id": 3,
          "content": "Elixir"
        },
        {
          "selected": false,
          "option_id": 4,
          "content": "JavaScript"
        }
      ]
    }
  ],
  "fill_question_answer": [
    {
      "question_type": "fill",
      "question_id": 2,
      "content": "I love it"
    }
  ]
}
```

# survey stats
curl "http://localhost:4000/api/v1/surveys/1/stats"

## survey stats return

```json
{
  "id": "1",
  "select_questions": [
    {
      "question_id": 1,
      "options": [
        {
          "selected_count": 0,
          "percentage": "0.0",
          "option_id": 1
        },
        {
          "selected_count": 1,
          "percentage": "12.5",
          "option_id": 2
        },
        {
          "selected_count": 2,
          "percentage": "25.0",
          "option_id": 3
        },
        {
          "selected_count": 1,
          "percentage": "12.5",
          "option_id": 4
        }
      ]
    }
  ],
  "fill_questions": [
    {
      "total": 2,
      "question_id": 2,
      "percentage": "50.0",
      "none_empty": 1
    }
  ]
}
```
