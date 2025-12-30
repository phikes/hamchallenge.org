FactoryBot.define do
  factory :toot do
    challenge
    completed { false }
    direct { false }
    username { "phikes" }
    url { "https://mastodon.social/posts/#{(1..10_000).to_a.sample}" }
    summary { "I did it! Very nice <3" }
  end
end
