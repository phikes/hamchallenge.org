class ChallengesController < ApplicationController
  def index
    @challenges = Challenge.where(year: APP_CONFIG.year).order week: :asc
  end
end
