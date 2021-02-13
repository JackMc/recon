class SlackClient
  def self.client
    Slack::Web::Client.new(token: Rails.application.credentials.slack_token)
  end
end
