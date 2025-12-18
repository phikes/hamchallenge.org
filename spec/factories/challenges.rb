FactoryBot.define do
  factory :challenge do
    year { 1 }
    week { 1 }
    category { 1 }
    difficulty { 1 }
    summary { "MyText" }
    description { "MyText" }
  end
end
