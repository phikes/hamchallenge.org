require "rails_helper"

RSpec.describe ProcessMastodonNotifications do
  describe "#call" do
    before { allow(Mastodon::REST::Client).to receive(:new).and_return client }

    let(:client) { instance_double Mastodon::REST::Client }

    it "only takes into account mentions" do
      allow(client).to receive(:notifications).and_return [Mastodon::Notification.new("id" => "123")]

      expect { described_class.call bearer_token: "very_secret_token" }.not_to change(Toot, :count)
    end

    it "only takes into account mentions which contain a HCnnS? token" do
      allow(client).to receive(:notifications).and_return [
        Mastodon::Notification.new(
          "id" => "123",
          "type" => "mention",
          "status" => {
            "id" => "123",
            "content" => "I just mention you, but no challenge!"
          }
        )
      ]

      expect { described_class.call bearer_token: "very_secret_token" }.not_to change(Toot, :count)
    end

    it "only takes into account mentions with a valid week" do
      allow(client).to receive(:notifications).and_return [
        Mastodon::Notification.new(
          "id" => "123",
          "type" => "mention",
          "status" => {
            "id" => "123",
            "content" => "bogus week HC53"
          }
        )
      ]

      expect { described_class.call bearer_token: "very_secret_token" }.not_to change(Toot, :count)
    end

    it "parses toots without success" do
      FactoryBot.create :challenge, week: 52

      allow(client).to receive(:notifications).and_return [
        Mastodon::Notification.new(
          "id" => "123",
          "type" => "mention",
          "status" => {
            "content" => "I am trying! HC52",
            "id" => "123",
            "url" => "https://mas.to/posts/123",
            "visibility" => "direct"
          },
          "account" => {
            "id" => "123",
            "acct" => "<a href=\"https://mas.to/@phikes\">@phikes</a>"
          }
        )
      ]
      allow(client).to receive(:dismiss_notification).with "123"

      expect { described_class.call bearer_token: "very_secret_token" }.to change(
        Toot.where(
          completed: false,
          direct: true,
          summary: "I am trying! HC52",
          url: "https://mas.to/posts/123",
          username: "@phikes"
        ),
        :count
      )
    end

    it "parses toots with success" do
      FactoryBot.create :challenge, week: 5

      allow(client).to receive(:notifications).and_return [
        Mastodon::Notification.new(
          "id" => "123",
          "type" => "mention",
          "status" => {
            "content" => "I did it! HC05S",
            "id" => "123",
            "url" => "https://mas.to/posts/123"
          },
          "account" => {
            "id" => "123",
            "acct" => "<a href=\"https://mas.to/@phikes\">@phikes</a>"
          }
        )
      ]
      allow(client).to receive(:dismiss_notification).with "123"

      expect { described_class.call bearer_token: "very_secret_token" }.to change(
        Toot.where(
          completed: true,
          direct: false,
          summary: "I did it! HC05S",
          url: "https://mas.to/posts/123",
          username: "@phikes"
        ),
        :count
      )
    end

    it "creates multiple toots per mention" do
      toot = FactoryBot.create :toot, challenge: FactoryBot.create(:challenge, week: 24), username: "@phikes"

      allow(client).to receive(:notifications).and_return [
        Mastodon::Notification.new(
          "id" => "123",
          "type" => "mention",
          "status" => {
            "content" => "I did it! HC24S",
            "id" => "123",
            "url" => "https://mas.to/posts/123"
          },
          "account" => {
            "id" => "123",
            "acct" => "<a href=\"https://mas.to/@phikes\">@phikes</a>"
          }
        )
      ]
      allow(client).to receive(:dismiss_notification).with "123"

      expect { described_class.call bearer_token: "very_secret_token" }.to change(
        Toot.where(
          completed: true,
          direct: false,
          summary: "I did it! HC24S",
          url: "https://mas.to/posts/123",
          username: "@phikes"
        ),
        :count
      )

      expect(Toot.count).to eq 2
    end

    it "updates a toot if the post is the same" do
      toot = FactoryBot.create :toot, challenge: FactoryBot.create(:challenge, week: 24), username: "@phikes", url: "https://mas.to/posts/123"

      allow(client).to receive(:notifications).and_return [
        Mastodon::Notification.new(
          "id" => "123",
          "type" => "mention",
          "status" => {
            "content" => "I did it! HC24S",
            "id" => "123",
            "url" => "https://mas.to/posts/123"
          },
          "account" => {
            "id" => "123",
            "acct" => "<a href=\"https://mas.to/@phikes\">@phikes</a>"
          }
        )
      ]
      allow(client).to receive(:dismiss_notification).with "123"

      expect { described_class.call bearer_token: "very_secret_token" }.to change(
        Toot.where(
          completed: true,
          direct: false,
          summary: "I did it! HC24S",
          url: "https://mas.to/posts/123",
          username: "@phikes"
        ),
        :count
      )

      expect(Toot.count).to eq 1
    end
  end
end
