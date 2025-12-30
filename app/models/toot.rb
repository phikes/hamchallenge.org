class Toot < ApplicationRecord
  belongs_to :challenge

  scope :completed, -> { where completed: true }
end
