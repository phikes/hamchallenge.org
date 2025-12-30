class TootsController < ApplicationController
  def index
    @challenge = Challenge.find params[:challenge_id]
    @toots = @challenge.toots.order(created_at: :asc)
    @user_scores = Toot
      .includes(:challenge)
      .where(challenge: {year: APP_CONFIG.year})
      .completed
      .group(:username)
      .distinct
      .count :challenge_id
  end
end
