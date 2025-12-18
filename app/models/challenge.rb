class Challenge < ApplicationRecord
  enum :category, {fun: 0, radio: 1, computer: 2, social: 3, homebrew: 4}
  enum :difficulty, {easy: 0, medium: 1, hard: 2}

  validates :week, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 52 }
  validates :year, numericality: { greater_than_or_equal_to: 0 }
end
