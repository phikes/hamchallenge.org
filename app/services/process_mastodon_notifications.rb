class ProcessMastodonNotifications < ApplicationService
  BASE_URL = "https://mas.to"
  HC_REGEX = /[hH][cC](?<week>\d{2})(?<success>S?)/

  option :bearer_token, DryTypes::String

  def call
    client.notifications.each do |notification|
      next unless notification.type == "mention"

      hc_match = notification.status.content.match HC_REGEX
      next unless hc_match.present?

      week = hc_match[:week].to_i
      next unless week.in? 1..52

      success = hc_match[:success].present?

      challenge = Challenge.find_by(year: APP_CONFIG.year, week:)
      next unless challenge

      toot = challenge.toots.find_or_initialize_by username: strip_tags(notification.account.acct), url: strip_tags(notification.status.url)
      toot.assign_attributes completed: success,
        direct: notification.status.visibility == "direct",
        status_created_at: notification.status.created_at,
        summary: strip_tags(notification.status.content)
      toot.save!

      client.dismiss_notification notification.id
    end
  end

  protected

  def client
    @client ||= Mastodon::REST::Client.new base_url: BASE_URL, bearer_token:
  end

  def strip_tags(input)
    ActionText::Content.new(input).to_plain_text
  end
end
