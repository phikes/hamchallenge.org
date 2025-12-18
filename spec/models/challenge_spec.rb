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
end
