load 'basefile.rb'

class SlackApi
  class << self
    def client(channel)
      Slack::Notifier.new "https://hooks.slack.com/services/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",
        channel: channel,
        username: "お知らせ"
    end

    def say(content, channel: "#{ENV['APP_NAME']}",force: true)
      if force
        client(channel).ping(content)
      elsif ENV['RAILS_ENV'] == 'production'
        client(channel).ping(content)
      end
    end
  end
end
