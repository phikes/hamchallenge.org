require "rails_helper"

RSpec.describe "Challenges index", type: :feature do
  it "shows the challenges" do
    # this one doesn't count towards anything on the page as its in another year
    FactoryBot.create(:challenge, week: 1, year: 2003).tap do |challenge|
      FactoryBot.create(:toot, challenge:, username: "none_user")
      FactoryBot.create :toot, challenge:, completed: true
      FactoryBot.create :toot, challenge:, completed: true
    end
    FactoryBot.create(:challenge, week: 1, year: 2005, summary: "Do something fun!", description: "SOMETHING FUN", difficulty: :easy, category: "fun").tap do |challenge|
      FactoryBot.create(:toot, challenge:, username: "none_user")
      FactoryBot.create :toot, challenge:, completed: true
      FactoryBot.create :toot, challenge:, completed: true # don't count this twice in finished by / leaderboard
    end
    FactoryBot.create(:challenge, week: 2, year: 2005, summary: "Do something social!", description: "SOMETHING SOCIAL", difficulty: :medium, category: "social").tap do |challenge|
      FactoryBot.create :toot, challenge:, completed: true
    end
    FactoryBot.create(:challenge, week: 3, year: 2005, summary: "Do something with your computer!", description: "SOMETHING COMPUTER", difficulty: :hard, category: "computer").tap do |challenge|
      FactoryBot.create :toot, challenge:
    end
    FactoryBot.create(:challenge, week: 4, year: 2005, summary: "Make something!", description: "SOMETHING SOMETHING", difficulty: :easy, category: "homebrew").tap do |challenge|
      FactoryBot.create :toot, challenge:, username: "second_user", completed: true
    end
    FactoryBot.create :challenge, week: 5, year: 2005, summary: "Do something with your radio!", description: "SOMETHING RADIO", difficulty: :easy, category: "radio"

    visit "/"

    expect(page).to have_text "2005"

    expect(page).to have_table :challenges, with_rows: [
      {
        "Week" => 1,
        "Type" => "😂",
        "Difficulty" => "🟢",
        "Challenge" => "Do something fun!",
        "Toots / Finished by" => "3 / 1"
      },
      {
        "Week" => 2,
        "Type" => "🧑‍🤝‍🧑",
        "Difficulty" => "🟠",
        "Challenge" => "Do something social!",
        "Toots / Finished by" => "1 / 1"
      },
      {
        "Week" => 3,
        "Type" => "🖥️",
        "Difficulty" => "🔴",
        "Challenge" => "Do something with your computer!",
        "Toots / Finished by" => "1 / 0"
      },
      {
        "Week" => 4,
        "Type" => "🛠️",
        "Difficulty" => "🟢",
        "Challenge" => "Make something!",
        "Toots / Finished by" => "1 / 1"
      },
      {
        "Week" => 5,
        "Type" => "📻",
        "Difficulty" => "🟢",
        "Challenge" => "Do something with your radio!",
        "Toots / Finished by" => "0 / 0"
      }
    ]

    expect(page).to have_table :leaderboard, exact: true, with_rows: [
      {
        "User" => "phikes",
        "User Score" => 2
      },
      {
        "User" => "second_user",
        "User Score" => 1
      }
    ]
  end
end
