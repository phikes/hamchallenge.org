class UsersController < ApplicationController
  class << self
    def weeks_count(year)
      last_day = Date.new(year).end_of_year

      if last_day.cweek == 1
        last_day.prev_week.cweek
      else
        last_day.cweek
      end
    end
  end

  WEEKS_BY_MONTH = (1..weeks_count(APP_CONFIG.year)).each_with_object({}) do |week, months|
    beginning_of_week = Date.commercial APP_CONFIG.year, week, 1
    end_of_week = Date.commercial APP_CONFIG.year, week, 7

    week_date_within_year = beginning_of_week.year == APP_CONFIG.year ? beginning_of_week : end_of_week
    month = week_date_within_year.month

    months[month] ||= []

    months[month] << week
  end

  def show
    @username = params[:id]

    @toots = Toot
      .includes(:challenge)
      .where(challenges: {year: APP_CONFIG.year}, username: @username)
      .order created_at: :asc

    @completed_count = @toots.completed.distinct.count :challenge_id

    @in_progress_count = Challenge
      .where(year: APP_CONFIG.year)
      .where_assoc_not_exists(:toots, username: @username, completed: true)
      .where_assoc_exists(:toots, username: @username)
      .count

    @not_started_count = Challenge
      .where(year: APP_CONFIG.year)
      .where_assoc_not_exists(:toots, username: @username)
      .count

    @challenges_with_status = Challenge
      .where(year: APP_CONFIG.year)
      .with_status(@username)
      .group_by(&:week)
  end
end
