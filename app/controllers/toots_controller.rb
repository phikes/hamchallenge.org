class TootsController < ApplicationController
  def index
    @challenge = Challenge.find params[:challenge_id]
    @toots = @challenge.toots.order(updated_at: :asc)
    @user_scores = Toot.completed.group(:username).count
  end
end
