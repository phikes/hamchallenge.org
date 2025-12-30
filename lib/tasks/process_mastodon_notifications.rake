task process_mastodon_notifications: %i[environment] do
  ProcessMastodonNotifications.call bearer_token: ENV.fetch("MASTODON_ACCESS_TOKEN")
end
