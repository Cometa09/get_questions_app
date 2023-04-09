30.times do
    body = Faker::Lorem.sentence(word_count: 5, supplemental: true, random_words_to_add: 4) 
    title = Faker::Hipster.sentence(word_count: 3)
    Question.create title: title, body: body
end