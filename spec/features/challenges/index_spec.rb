require "rails_helper"

RSpec.describe "Challenges index", type: :feature do
  it "shows the challenges" do
    FactoryBot.create(:challenge, week: 1, year: 2005, summary: "Do something fun!", description: "SOMETHING FUN", difficulty: :easy, category: "fun").tap do |challenge|
      FactoryBot.create(:toot, challenge:, username: "none_user")
      FactoryBot.create :toot, challenge:, completed: true
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

    challenges_table = find :table, "Challenges"
    expect(challenges_table).to have_table_row "Week" => 1, "Type" => "😂", "Difficulty" => "🟢", "Challenge" => "Do something fun!", "Toots / Finished by" => "2 / 1"
    expect(challenges_table).to have_table_row "Week" => 2, "Type" => "🧑‍🤝‍🧑", "Difficulty" => "🟡", "Challenge" => "Do something social!", "Toots / Finished by" => "1 / 1"
    expect(challenges_table).to have_table_row "Week" => 3, "Type" => "🖥️", "Difficulty" => "🔴", "Challenge" => "Do something with your computer!", "Toots / Finished by" => "1 / 0"
    expect(challenges_table).to have_table_row "Week" => 4, "Type" => "🛠️", "Difficulty" => "🟢", "Challenge" => "Make something!", "Toots / Finished by" => "1 / 1"
    expect(challenges_table).to have_table_row "Week" => 5, "Type" => "📻", "Difficulty" => "🟢", "Challenge" => "Do something with your radio!", "Toots / Finished by" => "0 / 0"

    leaderboard_table = find :table, "Leaderboard"
    expect(leaderboard_table).to have_table_row "User" => "phikes", "Challenges Finished" => 2
    expect(leaderboard_table).to have_table_row "User" => "second_user", "Challenges Finished" => 1
    expect(leaderboard_table).not_to have_table_row "User" => "none_user"
  end
end
