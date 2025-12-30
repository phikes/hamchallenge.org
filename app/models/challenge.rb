class Challenge < ApplicationRecord
  enum :category, {fun: 0, radio: 1, computer: 2, social: 3, homebrew: 4}
  enum :difficulty, {easy: 0, medium: 1, hard: 2}

  has_many :toots, dependent: :destroy

  scope :with_status, ->(username) do
    toot_table = Toot.arel_table

    select(
      Arel.star,
      Arel::Nodes::Case.new()
        .when(
          Arel::Nodes::Exists.new(
            toot_table
              .project
              .where(
                toot_table[:challenge_id]
                  .eq(
                    arel_table[:id]
                  )
                  .and(
                    toot_table[:username]
                      .eq(username)
                  )
                  .and(
                    toot_table[:completed]
                      .eq(true)
                  )
              )
          )
        )
        .then(Arel.sql("'completed'"))
        .when(
          Arel::Nodes::Exists.new(
            toot_table
              .project
              .where(
                toot_table[:challenge_id]
                  .eq(
                    arel_table[:id]
                  )
                  .and(
                    toot_table[:username]
                      .eq(username)
                  )
              )
          )
        )
        .then(Arel.sql("'in_progress'"))
        .else(Arel.sql("'not_started'"))
        .as("status")
    )
  end

  validates :week, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 52 }
  validates :year, numericality: { greater_than_or_equal_to: 0 }
end
