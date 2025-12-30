FactoryBot.define do
  factory :challenge do
    year { 2005 }
    week { 1 }
    category { "fun" }
    difficulty { "easy" }
    summary { "Do something!" }
    description { "Here are some instructions" }
  end
end
