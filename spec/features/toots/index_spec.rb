require "rails_helper"

RSpec.describe "Toots index", type: :feature do
  let(:challenge) { FactoryBot.create :challenge, week: 1 }

  it "shows the toots" do
    FactoryBot.create :toot, challenge: FactoryBot.create(:challenge, year: 2003), completed: true, summary: "DONE!", created_at: "2005-01-04T10:00:00Z", username: "phil"
    FactoryBot.create :toot, challenge:, completed: true, summary: "DONE!", created_at: "2005-01-04T10:00:00Z", username: "phil"
    FactoryBot.create :toot, challenge:, completed: true, summary: "DONE AGAIN!", created_at: "2005-01-04T10:00:00Z", username: "phil"
    FactoryBot.create :toot, completed: true, username: "phil"
    FactoryBot.create :toot, challenge:, summary: "Not yet", created_at: "2005-01-05T11:22:00Z", username: "fabian"

    visit "/challenges/#{challenge.id}/toots"

    expect(page).to have_text "2005"
    expect(page).to have_text "Week 1"
    expect(page).to have_text "Challenge for 2005-01-03 - 2005-01-09" # this is weird, I agree, but the first week of january doesn't start until the first monday
    expect(page).to have_text challenge.summary
    expect(page).to have_text challenge.description

    expect(page).to have_table "toots", exact: true, with_rows: [ # `exact` is necessary here, because capybara otherwise fuzzy finds the "User Score" column when querying for "User" and the test fails because the content doesn't match
      { "Date" => "January 04, 2005 10:00 UTC", "User" => "phil", "User Score" => "2", "Status" => "Success!", "Toot Summary & Link" => "DONE!" },
      { "Date" => "January 05, 2005 11:22 UTC", "User" => "fabian", "User Score" => "0", "Status" => "Working on it...", "Toot Summary & Link" => "Not yet" }
    ]
  end
end
