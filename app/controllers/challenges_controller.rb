class ChallengesController < ApplicationController
  def index
    @challenges = Challenge.where(year: APP_CONFIG.year).order week: :asc
    @toot_counts = Toot.group(:challenge_id).count
    @completed_toot_counts = Toot.completed.group(:challenge_id).count
    @users = Toot.completed.group(:username, :url).order(count_all: :desc).count
  end
end
