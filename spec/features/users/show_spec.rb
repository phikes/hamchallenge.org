require "rails_helper"

RSpec.describe "Users show", type: :feature do
  let(:challenge) { FactoryBot.create :challenge, week: 1 }
  let!(:progress_completed_toot) do
    FactoryBot.create :toot,
      completed: false,
      username: "phikes.social",
      status_created_at: "2005-01-04T09:00Z",
      challenge:
  end
  let!(:progress_toot) do
    FactoryBot.create :toot,
      completed: false,
      username: "phikes.social",
      status_created_at: "2005-01-05T09:00Z",
      challenge: FactoryBot.create(:challenge, week: 2)
  end
  let!(:completed_toot) do
    FactoryBot.create :toot,
      completed: true,
      username: "phikes.social",
      status_created_at: "2005-01-04T10:00Z",
      challenge:
  end

  before { FactoryBot.create :challenge } # this is the challenge that is not started

  it "shows the user page"  do
    FactoryBot.create(
      :toot,
      completed: true,
      username: "phikes.social",
      challenge:
    ) # make sure this doesn't get counted multiple times!
    visit "/users/phikes.social"

    expect(page).to have_text "52 Week Ham Radio Challenge 2005 - Status for phikes.social"
    expect(page).to have_table :toots, with_rows: [
      {"Date" => "January 04, 2005 09:00 UTC", "Challenge" => "1", "Status" => "Progress update...", "Toot Summary & Link" => progress_completed_toot.summary},
      {"Date" => "January 04, 2005 10:00 UTC", "Challenge" => "1", "Status" => "Success!", "Toot Summary & Link" => completed_toot.summary},
      {"Date" => "January 05, 2005 09:00 UTC", "Challenge" => "2", "Status" => "Progress update...", "Toot Summary & Link" => progress_toot.summary},
    ]

    expect(page).to have_text "Completed (1)"
    expect(page).to have_text "In progress (1)"
    expect(page).to have_text "Not started (1)"

    expect(page).to have_table "completed-challenges", with_rows: [
      ["January", "1 ✅", "2 🚧", "3 ⌛", "4 ⌛", "5 ⌛"],
      ["February", "6 ⌛", "7 ⌛", "8 ⌛", "9 ⌛"],
    ]
  end
end
