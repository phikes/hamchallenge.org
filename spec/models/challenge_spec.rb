require 'rails_helper'

RSpec.describe Challenge, type: :model do
  it { is_expected.to have_db_column(:category).of_type(:integer).with_options null: false }
  it { is_expected.to have_db_column(:description).of_type :text }
  it { is_expected.to have_db_column(:difficulty).of_type(:integer).with_options null: false }
  it { is_expected.to have_db_column(:summary).of_type(:text).with_options null: false }
  it { is_expected.to have_db_column(:week).of_type(:integer).with_options null: false }
  it { is_expected.to have_db_column(:year).of_type(:integer).with_options null: false }

  it { is_expected.to validate_numericality_of(:year).is_greater_than_or_equal_to 0 }
  it { is_expected.to validate_numericality_of(:week).is_greater_than_or_equal_to(1).is_less_than_or_equal_to 52 }

  it { is_expected.to define_enum_for(:category).with_values fun: 0, radio: 1, computer: 2, social: 3, homebrew: 4 }
  it { is_expected.to define_enum_for(:difficulty).with_values easy: 0, medium: 1, hard: 2 }

  it { is_expected.to have_many(:toots).dependent :destroy }

  describe "::with_status(username)" do
    subject { described_class.with_status "phikes" }

    let(:completed_challenge) { FactoryBot.create :challenge }
    let(:not_started_challenge) { FactoryBot.create :challenge }
    let(:in_progress_challenge) { FactoryBot.create :challenge }

    before do
      FactoryBot.create :toot, challenge: completed_challenge
      FactoryBot.create :toot, completed: true, challenge: completed_challenge
      FactoryBot.create :toot, completed: true, challenge: completed_challenge, username: "someone else"
      FactoryBot.create :toot, challenge: not_started_challenge, username: "someone else"
      FactoryBot.create :toot, challenge: in_progress_challenge
      FactoryBot.create :toot, completed: true, challenge: in_progress_challenge, username: "someone else"
    end

    it do
      is_expected.to contain_exactly(
        an_object_having_attributes(id: completed_challenge.id, status: "completed"),
        an_object_having_attributes(id: not_started_challenge.id, status: "not_started"),
        an_object_having_attributes(id: in_progress_challenge.id, status: "in_progress"),
      )
    end
  end
end
