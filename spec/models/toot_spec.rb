require 'rails_helper'

RSpec.describe Toot, type: :model do
  it { is_expected.to belong_to :challenge }
  it { is_expected.to have_db_column(:completed).of_type(:boolean).with_options null: false }
  it { is_expected.to have_db_column(:direct).of_type(:boolean).with_options null: false }
  it { is_expected.to have_db_column(:username).of_type(:string).with_options null: false }
  it { is_expected.to have_db_column(:url).of_type(:string).with_options null: false }
  it { is_expected.to have_db_column(:summary).of_type(:text).with_options null: false }
end
