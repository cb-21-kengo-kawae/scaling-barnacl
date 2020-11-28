# Ridgepole を扱うユーティリティ
class RidgepoleUtil
  def self.client(config, options)
    config ||= Rails.application.config.database_configuration[Rails.env]
    Ridgepole::Client.new(config, options)
  end
end
