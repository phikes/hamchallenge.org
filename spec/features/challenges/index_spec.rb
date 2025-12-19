require "rails_helper"

RSpec.describe "Challenges index", type: :feature do
  it "shows the challenges" do
    FactoryBot.create :challenge, week: 1, year: 2005, summary: "Do something fun!", difficulty: :easy, category: "fun"
    FactoryBot.create :challenge, week: 2, year: 2005, summary: "Do something social!", difficulty: :medium, category: "social"
    FactoryBot.create :challenge, week: 3, year: 2005, summary: "Do something with your computer!", difficulty: :hard, category: "computer"
    FactoryBot.create :challenge, week: 4, year: 2005, summary: "Make something!", difficulty: :easy, category: "homebrew"
    FactoryBot.create :challenge, week: 5, year: 2005, summary: "Do something with your radio!", difficulty: :easy, category: "radio"

    visit "/"

    expect(page).to have_text "2005"

    challenges_table = find :table, "Challenges"

    expect(challenges_table).to have_table_row "Week" => 1, "Type" => "😂", "Difficulty" => "🟢", "Challenge" => "Do something fun!", "Toots / Finished by" => "0 / 0"
    expect(challenges_table).to have_table_row "Week" => 2, "Type" => "🧑‍🤝‍🧑", "Difficulty" => "🟡", "Challenge" => "Do something social!", "Toots / Finished by" => "0 / 0"
    expect(challenges_table).to have_table_row "Week" => 3, "Type" => "🖥️", "Difficulty" => "🔴", "Challenge" => "Do something with your computer!", "Toots / Finished by" => "0 / 0"
    expect(challenges_table).to have_table_row "Week" => 4, "Type" => "🛠️", "Difficulty" => "🟢", "Challenge" => "Make something!", "Toots / Finished by" => "0 / 0"
    expect(challenges_table).to have_table_row "Week" => 5, "Type" => "📻", "Difficulty" => "🟢", "Challenge" => "Do something with your radio!", "Toots / Finished by" => "0 / 0"
  end
end
