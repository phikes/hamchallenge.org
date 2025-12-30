class ChallengesController < ApplicationController
  def index
    @challenges = Challenge
      .where(year: APP_CONFIG.year)
      .order week: :asc
    @toot_counts = Toot
      .includes(:challenge)
      .where(challenge: {year: APP_CONFIG.year})
      .group(:challenge_id)
      .count
    @completed_toot_counts = Toot
      .includes(:challenge)
      .where(challenge: {year: APP_CONFIG.year})
      .completed.distinct(:username)
      .group(:challenge_id)
      .distinct
      .count :username
    @users = Toot
      .includes(:challenge)
      .where(challenge: {year: APP_CONFIG.year})
      .completed
      .group(:username)
      .order(count: :desc)
      .distinct
      .count :challenge_id
  end
end
